//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit
import AdSupport
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
    private var hasOffers = false
    private var isOffersEnabled = false
    private var tags: [String: Any] = [:]
    private var widgetColor = ["000000", "000000"]
    private var headerColor = ["000000", "000000"]
    
    private var onReward: ((Float) -> ())?
    
    private var surveyDataSource: SurveyDataSource?
    
    var bitlabsAPI: BitLabsAPI? = nil
    
    private init() {}
    
    /// This is the essential function. Without it, the library will not function properly.
    /// So make sure you call it before using the library's functions
    /// - parameter token Your App Token, found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
    /// - parameter uid The id of the current user, this id is for you to keep track of which user got what.
    public func configure(token: String, uid: String) {
        self.token = token
        self.uid = uid
        
        bitlabsAPI = BitLabsAPI(token, uid)
        
        getAppSettings()
        
        getHasOffers()
        
        guard #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus
        else { return }
        
        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private func getAppSettings() {
        bitlabsAPI?.getAppSettings { visual, isOffersEnabled, currency in
            self.widgetColor = visual.surveyIconColor.extractColors
            self.headerColor = visual.navigationColor.extractColors
            self.isOffersEnabled = isOffersEnabled

            guard let currency = currency, currency.symbol.isImage else { return }
            self.currencyIcon = currency.symbol.content
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
        ifConfigured { bitlabsAPI?.checkSurveys(completionHandler) }
    }
    
    public func getSurveys(_ completionHandler: @escaping (Result<[Survey], Error>) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(completionHandler) }
    }
    
    public func getSurveyWidgets(surveys: [Survey], parent: UIViewController, type: WidgetType = .compact) -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = {
            switch type {
            case .simple: return CGSize(width: 310, height: 150)
            case .compact: return CGSize(width: 310, height: 85)
            case .full_width: return CGSize(width: 400, height: 55)
            }
        }()
        layout.minimumLineSpacing = CGFloat(4)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        surveyDataSource = SurveyDataSource(surveys: surveys, parent: parent, color: widgetColor.map { $0.toUIColor }, type: type)
        collectionView.dataSource = surveyDataSource
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        return collectionView
    }
    
    public func getLeaderboardView(parent: UIView, _ completionHandler: @escaping (LeaderboardView?) -> ()) {
        ifConfigured { bitlabsAPI?.getLeaderboard { response in
            guard let topUsers = response.topUsers else { return completionHandler(nil) }
            
            let leaderboardView = LeaderboardView(currencyIconUrl: self.currencyIcon, color: self.widgetColor.first?.toUIColor, frame: parent.bounds)
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
            webViewController.tags = tags
            webViewController.adId = adId
            webViewController.color = headerColor.map { $0.toUIColor }
            webViewController.token = token
            webViewController.sdk = "NATIVE"
            webViewController.delegate = self
            webViewController.shouldOpenExternally = hasOffers && isOffersEnabled
            
            webViewController.modalPresentationStyle = .overFullScreen
            
            parent.present(webViewController, animated: true)
        }
    }
    
    func rewardCompleted(_ value: Float) {
        onReward?(value)
    }
    
    func sendLeaveSurveyRequest(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        bitlabsAPI?.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason, completion: completion)
    }
    
    private func getHasOffers() {
        bitlabsAPI?.getHasOffers { self.hasOffers = $0 }
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
