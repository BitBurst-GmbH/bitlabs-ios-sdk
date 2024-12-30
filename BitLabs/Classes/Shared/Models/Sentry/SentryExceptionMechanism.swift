//
//  SentryExceptionMechanism.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryExceptionMechanism: Encodable {
    let type: String = "generic"
    let handled: Bool = true
    let data: Dictionary<String, String>? = nil
    let meta: Dictionary<String, String>? = nil
}
