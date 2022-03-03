//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit


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
	
	@objc public func hasSurveys(_ completionHandler: @escaping (Bool) -> ()) {
		bitlabsAPI.checkSurveys(completionHandler)
	}
	
	@objc public func setOnRewardCompletionHandler(_ completionHandler: @escaping (Float)-> ()) {
		browserDelegate.onRewardHandler = completionHandler
	}
	
	@objc public func launchOfferWall(parent: UIViewController) {
		browserDelegate.show(parent: parent, withUserId: uid, token: token, tags: tags, bitlabs: self)
	}
}
