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
    private var tags: [String: Any] = [:]
    private var headerColor = ["000000", "000000"]
    
    private var onReward: ((Float) -> ())?
    
    var bitlabsAPI: BitLabsAPI? = nil
    public var isDebugMode = false
    
    private init() {}
    
    /// This is the essential function. Without it, the library will not function properly.
    /// So make sure you call it before using the library's functions
    /// - parameter token Your App Token, found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
    /// - parameter uid The id of the current user, this id is for you to keep track of which user got what.
    @available(*, deprecated, message: "Use OFFERWALL instead")
    public func configure(token: String, uid: String) {
        self.token = token
        self.uid = uid
        
        SentryManager.shared.configure(token: token, uid: uid)
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": createUserAgent(),
            "X-Api-Token": token,
            "X-User-Id": uid
        ]
        
        bitlabsAPI = BitLabsAPI(URLSession(configuration: config))
        
        getAppSettings()
                
        guard #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus
        else { return }
        
        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private func getAppSettings() {
        bitlabsAPI?.getAppSettings(token: token) { configuration in
            let theme = "light"
            
            let navigationColor = configuration.first { $0.internalIdentifier == "app.visual.\(theme).navigation_color"}?.value ?? ""
            self.headerColor = navigationColor.extractColors
        }
    }
    
    @available(*, deprecated, message: "Use OFFERWALL instead")
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
    @available(*, deprecated, message: "Use OFFERWALL instead")
    public func setTags(_ tags: [String: Any]) {
        self.tags = tags
    }
    
    /// Adds a new tag to the current tags.
    /// - Parameters:
    ///   - key: The key of the tag.
    ///   - value: The value of the tag.
    @available(*, deprecated, message: "Use OFFERWALL instead")
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
    
    /// Shows the Leaderboard in the specified container.
    @available(*, deprecated, message: "Will be removed in the next major release")
    public func showLeaderboard(in container: UIView) {
        ifConfigured {
            let widget = WidgetView(frame: container.bounds, token: token, uid: uid, type: .leaderboard)
            container.replaceSubView(widget)
        }
    }
    
    /// Stores the reward completion closure to use on every reward completion.
    /// - Parameter rewardCompletionHandler: The closure to execute on Reward completions.
    @available(*, deprecated, message: "Use OFFERWALL instead")
    public func setRewardCompletionHandler(_ rewardCompletionHandler: @escaping (Float)-> ()) {
        onReward = rewardCompletionHandler
    }
    
    /// Presents a ViewController with a WebKitViewController to show the Offerwall.
    /// - Parameter parent: The presenting ViewController
    @available(*, deprecated, message: "Use OFFERWALL instead")
    public func launchOfferWall(parent: UIViewController) {
        ifConfigured {
            let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
            
            webViewController.uid = uid
            webViewController.initialURL = generateURL(uid: uid, token: token, sdk: "NATIVE", adId: adId, options: [:], tags: tags)
            
            webViewController.delegate = self
            webViewController.color = headerColor.map { $0.toUIColor ?? .black }
            
            webViewController.modalPresentationStyle = .overFullScreen
            
            parent.present(webViewController, animated: true)
        }
    }
    
    func offerwallClosed(_ value: Double) {
        onReward?(Float(value))
    }
    
    func rewardEarned(_ reward: Double) {}
    
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        bitlabsAPI?.leaveSurvey(clickId: clickId, reason: reason, completion: completion)
    }
    
    private func ifConfigured(block: () -> ()) {
        guard !token.isEmpty, !uid.isEmpty, bitlabsAPI != nil else {
            print("[BitLabs] You should configure BitLabs first! Call BitLabs::configure(token:uid:)")
            return
        }
        block()
    }
    
    public class OFFERWALL {
        public static func create(token: String, uid: String) -> Offerwall {
            return Offerwall(token: token, uid: uid)
        }
    }
}
