//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit


/// The main class including all the tools available to add SDK features into your code.
@objc public class BitLabs: NSObject {
	private let token: String
	private let uid: String
	
	private var tags: [String: Any] = [:]
	
	// TODO: Change to BitLabsAPI and use only Alamofire
	let restService: RestService
	let bitlabsAPI: BitLabsAPI
	let browserDelegate = BrowserDelegate.instance
	
	@objc public init(token: String, uid: String) {
		self.token = token
		self.uid = uid
		restService = RestService.Init(token: token, uid: uid)
		bitlabsAPI = BitLabsAPI(token, uid)
		browserDelegate.restService = restService
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
	
	@objc public func setOnRewardCompletionHandler(_ completionHandler: @escaping (Float)-> ()) {
		browserDelegate.onRewardHandler = completionHandler
	}
	
	@objc public func launchOfferWall(parent: UIViewController) {
		browserDelegate.show(parent: parent, withUserId: uid, token: token, tags: tags, bitlabs: self)
	}
}
