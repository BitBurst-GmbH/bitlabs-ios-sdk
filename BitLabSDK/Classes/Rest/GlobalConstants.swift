//
//  GlobalConstants.swift
//  BitLabSDK
//
//  Created by Frank Marx on 11.11.20.
//

import Foundation


enum ResponseStatusCodes: String, CaseIterable {
    
   case successStatusCode = "success"
    
}

enum Layout: String, CaseIterable {
    case LAYOUT_ONE = "LAYOUT_ONE"
    case LAYOUT_TWO = "LAYOUT_TWO"
}

enum Colors: String {
    case colorDark = "colorDark"
    case colorLight = "colorLight"
    case colorAccent = "colorAccent"
}


enum LeaveReason: String, CaseIterable {
    case tooSensitive = "Too sensitive"
    case uninteresting = "Uninteresting"
    case technical = "Technical issues"
    case tooLong = "Too long"
    case otherReasons = "Other reasons"
}


