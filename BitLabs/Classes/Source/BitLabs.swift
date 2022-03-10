//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit


/// The main class including all the tools available to add SDK features into your code.
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
	
	@objc public func setTags(_ tags: [String: Any]) {
		self.tags = tags
	}
	
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
	
	@objc public func setOnRewardHandler(_ onRewardHandler: @escaping (Float)-> ()) {
        onReward = onRewardHandler
	}
	
	@objc public func launchOfferWall(parent: UIViewController) {
        let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: Bundle(for: WebViewController.self))
        
        webViewController.uid = uid
        webViewController.token = token
        webViewController.tags = tags
        webViewController.bitLabsDelegate = self
        
        webViewController.modalPresentationStyle = .overFullScreen
        
        parent.present(webViewController, animated: true)
	}
    
    func onReward(_ value: Float) {
        onReward?(value)
    }
    
    func leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping ((Bool) -> ())) {
        bitlabsAPI.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason, completion: completion)
    }
}
