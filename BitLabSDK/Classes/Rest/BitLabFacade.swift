//
//  BitLabFacade.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.12.20.
//

import UIKit


public class BitLabFacade: BitLabInterface {
    
    let restService: RestService
    let browserDelegate: BrowserDelegate
    
    var token: String
    var uid: String
    
    private init(token t: String, uid u: String) {
        token = t
        uid = u
        restService = RestService.Init(token: token, uid: uid)
        browserDelegate = BrowserDelegate.instance
        browserDelegate.restService = restService
    }
    
    public static func Init(token: String, uid: String) ->  BitLabInterface {
        let this = BitLabFacade(token: token, uid: uid)
        return this
    }
    
    
    public func retrieveSettings(completion ch: @escaping retrieveSettingsResponseHandler) {
        restService.retrieveSettings(completion: ch)
    }
    
    public func checkForSurveys(completion ch: @escaping checkSurveyResponseHandler ) {
        restService.checkForSurveys(completion: ch)
    }
    
    public func show(parent p: UIViewController) {
        browserDelegate.show(parent: p, withUserId: uid, token: token, visual: restService.visual)
    }
    
}
