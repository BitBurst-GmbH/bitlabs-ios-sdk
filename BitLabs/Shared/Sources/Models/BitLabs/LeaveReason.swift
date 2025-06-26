//
//  LeaveReason.swift
//  BitLabs
//
//  Created by Omar Raad on 11.03.22.
//

import Foundation

/// - Tag: LeaveReason
enum LeaveReason: String, CaseIterable {
    case tooSensitive = "SENSITIVE"
    case uninteresting = "UNINTERESTING"
    case technical = "TECHNICAL"
    case tooLong = "TOO_LONG"
    case otherReasons = "OTHER"
}
