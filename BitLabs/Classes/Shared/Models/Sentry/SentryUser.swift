//
//  SentryUser.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryUser: Encodable {
    let id: String
    let email: String?
    let username: String?
    let ipAddress: String
    
    init(id: String, email: String? = nil, username: String? = nil, ipAddress: String = "{{auto}}") {
        self.id = id
        self.email = email
        self.username = username
        self.ipAddress = ipAddress
    }
}
