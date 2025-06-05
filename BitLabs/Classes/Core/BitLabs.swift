//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit
import AdSupport
import Alamofire
import AppTrackingTransparency

/// The main class including all the tools available to add SDK features into your code.
///
/// This is a singleton object, so you'll have one `shared` instance throughout the whole main process(app lifecycle)
/// - Tag: BitLabs
public class BitLabs: WebViewDelegate {
    public static let shared = BitLabs()
    
    private var uid = ""
    private var adId = ""
    private var token = ""
    private var currencyIcon = ""
    private var bonusPercentage = 0.0
    private var tags: [String: Any] = [:]
    private var widgetColor = ["000000", "000000"]
    private var headerColor = ["000000", "000000"]
    
    private var onReward: ((Float) -> ())?
    
    private var surveyDataSource: SurveyDataSource?
    
    var bitlabsAPI: BitLabsAPI? = nil
    public var isDebugMode = false
    
    private init() {}
    
    /// This is the essential function. Without it, the library will not function properly.
    /// So make sure you call it before using the library's functions
    /// - parameter token Your App Token, found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
    /// - parameter uid The id of the current user, this id is for you to keep track of which user got what.
    public func configure(token: String, uid: String) {
        self.token = token
        self.uid = uid
        
        SentryManager.shared.configure(token: token, uid: uid)
        
        bitlabsAPI = BitLabsAPI(Session(interceptor: BitLabsRequestInterceptor(token, uid)))
        
        getAppSettings()
                
        guard #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus
        else { return }
        
        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private func getAppSettings() {
        bitlabsAPI?.getAppSettings(token: token) { configuration in
            let theme = "light"
            
            let surveyIconColor = configuration.first { $0.internalIdentifier == "app.visual.\(theme).survey_icon_color"}?.value ?? ""
            self.widgetColor = surveyIconColor.extractColors
            
            let navigationColor = configuration.first { $0.internalIdentifier == "app.visual.\(theme).navigation_color"}?.value ?? ""
            self.headerColor = navigationColor.extractColors
            
            let isImage = configuration.first { $0.internalIdentifier == "general.currency.symbol.is_image" }?.value ?? "0"
            let content = configuration.first { $0.internalIdentifier == "general.currency.symbol.content"}?.value ?? ""
            self.currencyIcon = isImage == "1" ? content : ""
        }
    }
    
    public func requestTrackingAuthorization() {
        guard #available(iOS 14, *) else { return }
        
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                self.adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            default:
                break
            }
        }
    }
        
    /// Sets the tags which will be used as query parameters in the Offerwall URL.
    ///
    /// - Warning: This will replace the currently stored tags with the newly input ones.
    /// - Parameter tags: The dictionary of tags to store in the [BitLabs](x-source-tag://BitLabs) Class
    public func setTags(_ tags: [String: Any]) {
        self.tags = tags
    }
    
    /// Adds a new tag to the current tags.
    /// - Parameters:
    ///   - key: The key of the tag.
    ///   - value: The value of the tag.
    public func addTag(key: String, value: String) {
        tags[key] = value
    }
    
    ///  Determines whether the user can perform an action in the Offer Wall (either opening a survey or answering qualifications).
    ///
    ///  If you want to perform background checks if surveys are available, this is the best option.
    ///
    /// - Parameter completionHandler: A closure which executes after a result is recieve
    /// - Parameter hasSurveys: A Bool which indicates whether an action can be performed by the user or not.
    public func checkSurveys(_ completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(sdk: "NATIVE") { result in
            switch result {
            case .success(let surveys): completionHandler(.success(!surveys.isEmpty))
            case .failure(let error): completionHandler(.failure(error))
            }}}
    }
    
    public func getSurveys(_ completionHandler: @escaping (Result<[Survey], Error>) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(sdk: "NATIVE") { result in
            switch result {
            case .success(let surveys): completionHandler(.success(surveys))
            case .failure(let error): completionHandler(.failure(error))
            }}}
    }
    
    public func showSurveyWidget(in container: UIView, type: WidgetType = .simple) {
        ifConfigured {
            let widget = WidgetView(frame: container.bounds, token: token, uid: uid, type: type)
            container.replaceSubView(widget)
            widget.center.x = container.center.x
        }
    }
    
    @available(*, deprecated, message: "Use showSurveyWidget(in:type:) instead.")
    public func getSurveyWidgets(surveys: [Survey], parent: UIViewController, type: WidgetType = .compact) -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = {
            switch type {
            case .simple: return CGSize(width: 310, height: 150)
            case .compact: return CGSize(width: 310, height: 85)
            case .full_width: return CGSize(width: 450, height: 50)
            default: return CGSize(width: 310, height: 150)
            }
        }()
        layout.minimumLineSpacing = CGFloat(4)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        surveyDataSource = SurveyDataSource(surveys: surveys, parent: parent, color: widgetColor.map { $0.toUIColor ?? .black }, currencyUrl: currencyIcon, bonus: bonusPercentage, type: type)
        collectionView.dataSource = surveyDataSource
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        return collectionView
    }
    
    /// Shows the Leaderboard in the specified container.
    public func showLeaderboard(in container: UIView) {
        ifConfigured {
            let widget = WidgetView(frame: container.bounds, token: token, uid: uid, type: .leaderboard)
            container.replaceSubView(widget)
        }
    }
    
    @available(*, deprecated, message: "Use showLeaderboard(in:) instead.")
    public func getLeaderboardView(_ completionHandler: @escaping (LeaderboardView?) -> ()) {
        ifConfigured { bitlabsAPI?.getLeaderboard { response in
            guard let topUsers = response.topUsers, !topUsers.isEmpty else { return completionHandler(nil) }
            
            let leaderboardView = LeaderboardView(currencyIconUrl: self.currencyIcon, color: self.widgetColor.first?.toUIColor, frame: CGRect())
            leaderboardView.ownUser = response.ownUser
            leaderboardView.rankings = topUsers
            
            completionHandler(leaderboardView)
        }}
    }
    
    /// Stores the reward completion closure to use on every reward completion.
    /// - Parameter rewardCompletionHandler: The closure to execute on Reward completions.
    public func setRewardCompletionHandler(_ rewardCompletionHandler: @escaping (Float)-> ()) {
        onReward = rewardCompletionHandler
    }
    
    /// Presents a ViewController with a WebKitViewController to show the Offerwall.
    /// - Parameter parent: The presenting ViewController
    public func launchOfferWall(parent: UIViewController) {
        ifConfigured {
            let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
            
            webViewController.uid = uid
            webViewController.initialURL = generateURL(uid: uid, token: token, sdk: "NATIVE", adId: adId, tags: tags)
            
            webViewController.delegate = self
            webViewController.color = headerColor.map { $0.toUIColor ?? .black }
            
            webViewController.modalPresentationStyle = .overFullScreen
            
            parent.present(webViewController, animated: true)
        }
    }
    
    func rewardCompleted(_ value: Float) {
        onReward?(value)
    }
    
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        bitlabsAPI?.leaveSurvey(clickId: clickId, reason: reason, completion: completion)
    }
    
    func getCurrencyIcon(currencyIconUrl: String, _ completion: @escaping (UIImage?) -> ()) {
        bitlabsAPI?.getCurrencyIcon(url: currencyIconUrl, completion)
    }
    
    private func ifConfigured(block: () -> ()) {
        guard !token.isEmpty, !uid.isEmpty, bitlabsAPI != nil else {
            print("[BitLabs] You should configure BitLabs first! Call BitLabs::configure(token:uid:)")
            return
        }
        block()
    }
}
