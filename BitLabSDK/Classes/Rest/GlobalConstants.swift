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

enum Colors: String {
    case colorDark = "colorDark"
    case colorLight = "colorLight"
    case colorAccent = "colorAccent"
}


enum LeaveReson: String {
    case sensitive = "SENSITIVE"
    case uninteresting = "UNINTERESTING"
    case technical = "TECHNICAL"
    case tooLong = "TOO_LONG"
    case other = "OTHER"
}
