//
//  Strings.swift
//  BitLabs
//
//  Created by Omar Raad on 11.03.22.
//

import Foundation

/// This class is used to get all localized strings
class Localized {
    static let leaveTitle = "LEAVE_TITLE".localized
    static let leaveDescription = "LEAVE_DESC".localized
    static let continueSurvey = "CONTINUE_SURVEY".localized
}

let bundle = Bundle(for: WebViewController.self)

extension String {
    var localized: String {
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
