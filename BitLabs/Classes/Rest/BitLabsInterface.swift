//
//  BitLabInterface.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.12.20.
//

import UIKit



public protocol BitLabsInterface {
    
    // Rest - Based methods
    func retrieveSettings(completion: @escaping retrieveSettingsResponseHandler)
    
    func checkForSurveys(completion: @escaping checkSurveyResponseHandler)
    
    // Browser - Based methods
    func show(parent: UIViewController)
    
}
