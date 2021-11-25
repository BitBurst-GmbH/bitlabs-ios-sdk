//
//  BitLabs.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit


@objc public class BitLabs : NSObject {
    
    let restService: RestService
    let browserDelegate: BrowserDelegate
    
    var token: String
    var uid: String
    var tags: Dictionary<String, Any>
    
    private init(token t: String, uid u: String) {
        token = t
        uid = u
        tags = [:]
        restService = RestService.Init(token: token, uid: uid)
        browserDelegate = BrowserDelegate.instance
        browserDelegate.restService = restService
    }
    
    @objc public static func Init(token: String, uid: String) ->  BitLabs {
        let this = BitLabs(token: token, uid: uid)
        return this
    }
    
    @objc public func setTags(t: Dictionary<String, Any>){
        tags = t
    }
    
    @objc public func appendTag(key: String, value: String){
        tags[key] = value
    }
    
    @objc public func hasSurveys(completionHandler: @escaping (Bool)-> ()) {
        restService.checkForSurveys(completionHandler: completionHandler)
    }
    
    @objc public func show(parent p: UIViewController) {
        browserDelegate.show(parent: p, withUserId: uid, token: token, tags: tags)
    }
    
}
