//
//  SentryExceptionMechanism.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryExceptionMechanism: Encodable {
    let type: String
    let handled: Bool
    let data: Dictionary<String, String>?
    let meta: Dictionary<String, String>?
    
    init(type: String = "generic", handled: Bool = true, data: Dictionary<String, String>? = nil, meta: Dictionary<String, String>? = nil) {
        self.type = type
        self.handled = handled
        self.data = data
        self.meta = meta
    }
}
