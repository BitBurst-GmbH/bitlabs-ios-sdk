//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit


/// The main class including all the tools available to add SDK features into your code.
/// - Tag: BitLabs
@objc public class BitLabs: NSObject, WebViewDelegate {
    
	private let token: String
	private let uid: String
	
	private var tags: [String: Any] = [:]
    
    private var onReward: ((Float) -> ())?
	
	let bitlabsAPI: BitLabsAPI
	
	@objc public init(token: String, uid: String) {
		self.token = token
		self.uid = uid
		bitlabsAPI = BitLabsAPI(token, uid)
	}
    
    /// Sets the tags.
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
		bitlabsAPI.checkSurveys(completionHandler)
	}
    
    /// Stores the reward completion closure to use on every reward completion.
    /// - Parameter rewardCompletionHandler: The closure to execute on Reward completions.
	@objc public func setRewardCompletionHandler(_ rewardCompletionHandler: @escaping (Float)-> ()) {
        onReward = rewardCompletionHandler
	}
    
    /// Presents a ViewController with a WebKitViewController to show the Offerwall.
    /// - Parameter parent: The presenting ViewController
	@objc public func launchOfferWall(parent: UIViewController) {
        let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        webViewController.uid = uid
        webViewController.token = token
        webViewController.tags = tags
        webViewController.delegate = self
        
        webViewController.modalPresentationStyle = .overFullScreen
        
        parent.present(webViewController, animated: true)
	}
    
    func rewardCompleted(_ value: Float) {
        onReward?(value)
    }
    
    func sendLeaveSurveyRequest(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping ((Bool) -> ())) {
        bitlabsAPI.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason, completion: completion)
    }
}
