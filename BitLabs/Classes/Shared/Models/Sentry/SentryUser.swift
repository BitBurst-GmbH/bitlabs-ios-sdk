//
//  SentryUser.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryUser: Encodable {
    let id: String
    let email: String? = nil
    let username: String? = nil
    let ipAddress: String = "{{auto}}"
}
