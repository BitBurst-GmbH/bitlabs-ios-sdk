//
//  SentryEvent.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEvent: Encodable {
    let eventId: String
    let timestamp: String
    let logentry: SentryMessage?
    let level: String?
    let platform: String
    let logger: String?
    let serverName: String?
    let release: String?
    let environment: String?
    let modules: Dictionary<String, String>?
    let extra: Dictionary<String, String>?
    let tags: Dictionary<String, String>?
    let fingerprint: [String]?
    let user: SentryUser?
    let sdk: SentrySDK
    let exception: [SentryException]?
}
