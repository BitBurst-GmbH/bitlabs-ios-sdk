//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit

/// The main class including all the tools available to add SDK features into your code.
///
/// This is a singleton object, so you'll have one `shared` instance throughout the whole main process(app lifecycle)
/// - Tag: BitLabs
public class BitLabs: WebViewDelegate {
    public static let shared = BitLabs()
    
    private var uid = ""
    private var token = ""
    private var hasOffers = false
    
    private var tags: [String: Any] = [:]
    
    private var onReward: ((Float) -> ())?
    
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
        
        getHasOffers()
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
    public func checkSurveys(_ completionHandler: @escaping (_ hasSurveys: Bool) -> ()) {
        ifConfigured { bitlabsAPI?.checkSurveys(completionHandler) }
    }
    
    public func getSurveys(_ completionHandler: @escaping ([Survey]?) -> ()) {
        ifConfigured { bitlabsAPI?.getSurveys(completionHandler) }
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
            webViewController.sdk = "NATIVE"
            webViewController.tags = tags
            webViewController.token = token
            webViewController.delegate = self
            webViewController.hasOffers = hasOffers
            
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
        bitlabsAPI?.getHasOffers { hasOffers in
            self.hasOffers = hasOffers ?? false
            print("has offers: \(self.hasOffers)")
        }
    }
    
    private func ifConfigured(block: () -> ()) {
        guard !token.isEmpty, !uid.isEmpty, bitlabsAPI != nil else {
            print("[BitLabs] You should configure BitLabs first! Call BitLabs::configure(token:uid:)")
            return
        }
        block()
    }
}
