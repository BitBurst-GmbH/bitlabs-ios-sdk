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
    case tooSensitive = "SENSITIVE"
    case uninteresting = "UNINTERESTING"
    case technical = "TECHNICAL"
    case tooLong = "TOO_LONG"
    case otherReasons = "OTHER"
}
