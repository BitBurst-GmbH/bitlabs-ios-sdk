//
//  SentryMessage.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryMessage: Encodable {
    let formatted: String
    let message: String?
    let params: [String]?
    
    init(formatted: String, message: String? = nil, params: [String]? = nil) {
        self.formatted = formatted
        self.message = message
        self.params = params
    }
}
