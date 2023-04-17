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
@objc public class BitLabs: NSObject, WebViewDelegate {
    @objc public static let shared = BitLabs()
    
    private var uid = ""
    private var adId = ""
    private var token = ""
    private var widgetColor = ["", ""]
    private var headerColor = ["", ""]
    private var hasOffers = false
    private var isOffersEnabled = false
    private var tags: [String: Any] = [:]
    
    private var onReward: ((Float) -> ())?
    
    var bitlabsAPI: BitLabsAPI? = nil
    
    private override init() {}
    
    /// This is the essential function. Without it, the library will not function properly.
    /// So make sure you call it before using the library's functions
    /// - parameter token Your App Token, found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
    /// - parameter uid The id of the current user, this id is for you to keep track of which user got what.
    @objc public func configure(token: String, uid: String) {
        self.token = token
        self.uid = uid
        
        bitlabsAPI = BitLabsAPI(token, uid)
        
        getWidgetColor()
        
        getHasOffers()
        
        guard #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus
        else { return }
        
        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private func getWidgetColor() {
        bitlabsAPI?.getAppSettings { visual, isOffersEnabled, _ in
            self.widgetColor = visual.surveyIconColor.extractColors
            self.headerColor = visual.navigationColor.extractColors
            self.isOffersEnabled = isOffersEnabled
        }
    }
    
    @objc public func requestTrackingAuthorization() {
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
    @objc public func setTags(_ tags: [String: Any]) {
        self.tags = tags
    }
    
    /// Adds a new tag to the current tags.
    /// - Parameters:
    ///   - key: The key of the tag.
    ///   - value: The value of the tag.
    @objc public func addTag(key: String, value: String) {
        tags[key] = value
    }
    
    ///  Determines whether the user can perform an action in the Offer Wall (either opening a survey or answering qualifications).
    ///
    ///  If you want to perform background checks if surveys are available, this is the best option.
    ///
    /// - Parameter completionHandler: A closure which executes after a result is recieve
    /// - Parameter hasSurveys: A Bool which indicates whether an action can be performed by the user or not.
    @objc public func checkSurveys(_ completionHandler: @escaping (_ hasSurveys: Bool) -> ()) {
        ifConfigured { bitlabsAPI?.checkSurveys { result in
            switch result {
            case .failure(let error):
                print("[BitLabs] Check For Surveys \(error)")
                completionHandler(false)
            case .success(let hasSurveys):
                completionHandler(hasSurveys)
            }
        }}
    }
    
    @objc public func getSurveys(_ completionHandler: @escaping ([Survey]) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys { result in
            switch result {
            case .failure(let error):
                print("[Example] Get Surveys \(error)")
            case .success(let surveys):
                completionHandler(surveys)
            }
        }}
    }
    
    @objc public func getLeaderboard(_ completionHandler: @escaping (GetLeaderboardResponse) -> ()) {
        ifConfigured { bitlabsAPI?.getLeaderboard(completionHandler) }
    }
    
    /// Stores the reward completion closure to use on every reward completion.
    /// - Parameter rewardCompletionHandler: The closure to execute on Reward completions.
    @objc public func setRewardCompletionHandler(_ rewardCompletionHandler: @escaping (Float)-> ()) {
        onReward = rewardCompletionHandler
    }
    
    /// Presents a ViewController with a WebKitViewController to show the Offerwall.
    /// - Parameter parent: The presenting ViewController
    @objc public func launchOfferWall(parent: UIViewController) {
        ifConfigured {
            let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
            
            webViewController.uid = uid
            webViewController.tags = tags
            webViewController.adId = adId
            webViewController.sdk = "UNITY"
            webViewController.token = token
            webViewController.delegate = self
            webViewController.color = headerColor.map { $0.toUIColor }
            webViewController.shouldOpenExternally = hasOffers && isOffersEnabled
            
            webViewController.modalPresentationStyle = .overFullScreen
            
            parent.present(webViewController, animated: true)
        }
    }
    
    @objc public func getColor() -> [String] {
        return widgetColor
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
    
    private func ifConfigured(block: () -> ()) {
        guard !token.isEmpty, !uid.isEmpty, bitlabsAPI != nil else {
            print("[BitLabs] You should configure BitLabs first! Call BitLabs::configure(token:uid:)")
            return
        }
        block()
    }
}
