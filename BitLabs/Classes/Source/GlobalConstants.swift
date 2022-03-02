//
//  GlobalConstants.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 11.11.20.
//

import Foundation

enum ResponseStatusCodes: String, CaseIterable {
   case successStatusCode = "success"
}

enum Layout: String, CaseIterable {
    case LAYOUT_ONE = "LAYOUT_ONE"
    case LAYOUT_TWO = "LAYOUT_TWO"
}

enum LeaveReason: String, CaseIterable {
    case tooSensitive = "TOO_SENSITIVE"
    case uninteresting = "UNINSTERESTING"
    case technical = "TECHNICAL_ISSUES"
    case tooLong = "TOO_LONG"
    case otherReasons = "OTHER_REASONS"
}
