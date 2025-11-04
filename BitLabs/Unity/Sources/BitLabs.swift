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
    private var headerColor = ["", ""]
    
    private var tags: [String: Any] = [:]
    
    private var onReward: ((Float) -> ())?
    
    var isDebugMode = false
    var bitlabsAPI: BitLabsAPI? = nil
    
    private override init() {}
    
    /// This is the essential function. Without it, the library will not function properly.
    /// So make sure you call it before using the library's functions
    /// - parameter token Your App Token, found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
    /// - parameter uid The id of the current user, this id is for you to keep track of which user got what.
    /// - parameter onSuccess Callback executed when initialization succeeds
    /// - parameter onError Callback executed when initialization fails with error message
    @objc public func configure(token: String, uid: String, onSuccess: @escaping () -> (), onError: @escaping (String) -> ()) {
        do {
            guard !token.isEmpty else {
                throw NSError(domain: "BitLabs", code: 1, userInfo: [NSLocalizedDescriptionKey: "Token cannot be empty"])
            }
            guard !uid.isEmpty else {
                throw NSError(domain: "BitLabs", code: 2, userInfo: [NSLocalizedDescriptionKey: "UID cannot be empty"])
            }

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
            getWidgetColor()

            if #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus {
                adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }

            onSuccess()
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    private func getWidgetColor() {
        bitlabsAPI?.getAppSettings(token: token) { configuration in
            let theme = "light"
            
            let navigationColor = configuration.first { $0.internalIdentifier == "app.visual.\(theme).navigation_color"}?.value ?? ""
            self.headerColor = navigationColor.extractColors
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
    /// - Parameter onSuccess: A closure which executes with a Bool indicating whether surveys are available
    /// - Parameter onError: A closure which executes when an error occurs with the error message
    @objc public func checkSurveys(onSuccess: @escaping (_ hasSurveys: Bool) -> (), onError: @escaping (_ error: String) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(sdk: "UNITY") { result in
            switch result {
            case .success(let surveys): onSuccess(!surveys.isEmpty)
            case .failure(let error): onError(error.localizedDescription)
            }
        } }
    }
    
    @objc public func getSurveys(onSuccess: @escaping (_ surveys: [Survey]) -> (), onError: @escaping (_ error: String) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(sdk: "UNITY") { result in
            switch result {
            case .success(let surveys): onSuccess(surveys)
            case .failure(let error): onError(error.localizedDescription)
            }
        }}
    }
    
    /// Stores the reward completion closure to use on every reward completion.
    /// - Parameter rewardCompletionHandler: The closure to execute on Reward completions.
    @objc public func setRewardCompletionHandler(_ rewardCompletionHandler: @escaping (Float)-> ()) {
        onReward = rewardCompletionHandler
    }
    
    @objc public func setIsDebugMode(_ isDebugMode: Bool) {
        self.isDebugMode = isDebugMode
    }
    
    /// Presents a ViewController with a WebKitViewController to show the Offerwall.
    /// - Parameter parent: The presenting ViewController
    @objc public func launchOfferWall(parent: UIViewController) {
        ifConfigured {
            let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
            
            webViewController.uid = uid
            webViewController.initialURL = OfferwallURL(
                uid: uid,
                token: token,
                sdk: SubspecConfig.SDK,
                adId: adId,
                options: [:],
                tags: tags
            ).url
            
            webViewController.delegate = self
            webViewController.color = headerColor.map { $0.toUIColor ?? .black }
            
            webViewController.modalPresentationStyle = .overFullScreen
            
            parent.present(webViewController, animated: true)
        }
    }
    
    func offerwallClosed(_ totalReward: Double) {
        onReward?(Float(totalReward))
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
}
