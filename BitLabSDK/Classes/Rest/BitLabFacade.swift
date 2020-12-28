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
    
    public func checkForSurveys(forPlatform p:Platform, completion ch: @escaping checkSurveyResponseHandler ) {
        restService.checkForSurveys(forPlatform: p, completion: ch)
    }
    
    public func show(parent p: UIViewController, withUserId userId : String, token t: String, visual: Visual? ) {
        browserDelegate.show(parent: p, withUserId: userId, token: t, visual: visual)
    }
    
    public func show(parent p: UIViewController) {
        
    }
    
}

/*
 // Rest - Based methods
 func retrieveSettings(completion: @escaping retrieveSettingsResponseHandler)
 
 func checkForSurveys(forPlatform p:Platform, completion: @escaping checkSurveyResponseHandler )
 
 // Browser - Based methods
 
 func show(parent: UIViewController, withUserId userId : String, token: String )
 
 */
