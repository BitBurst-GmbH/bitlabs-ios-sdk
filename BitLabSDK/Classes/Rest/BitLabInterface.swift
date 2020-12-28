//
//  BitLabInterface.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.12.20.
//

import UIKit



public protocol BitLabInterface {
    
    // Rest - Based methods
    func retrieveSettings(completion: @escaping retrieveSettingsResponseHandler)
    
    func checkForSurveys(forPlatform p:Platform, completion: @escaping checkSurveyResponseHandler )
    
    // Browser - Based methods
    
    func show(parent: UIViewController, withUserId userId : String, token: String, visual: Visual? )
 
    func show(parent: UIViewController)
    
}