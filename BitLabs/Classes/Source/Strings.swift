//
//  Strings.swift
//  BitLabs
//
//  Created by Omar Raad on 11.03.22.
//

import Foundation

/// This class is used to get all localized strings
class Strings {
    static let leaveTitle = NSLocalizedString( "LEAVE_TITLE", bundle: bundle, value: "", comment: "")
    static let leaveDescription = NSLocalizedString( "LEAVE_DESC", bundle: bundle, value: "", comment: "")
    static let continueSurvey = NSLocalizedString("CONTINUE_SURVEY", bundle: bundle, value: "", comment: "")
    
    static func localized(_ string: String, value: String = "", comment: String = "") -> String {
        NSLocalizedString(string, bundle: bundle, value: value, comment: comment)
    }
}
