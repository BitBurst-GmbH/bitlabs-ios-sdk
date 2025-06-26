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
    let sdk: SentrySDK?
    let exception: [SentryException]?
    
    init(eventId: String, timestamp: String, logentry: SentryMessage? = nil, level: String? = nil, platform: String = "other", logger: String? = nil, serverName: String? = nil, release: String? = nil, environment: String? = nil, modules: Dictionary<String, String>? = nil, extra: Dictionary<String, String>? = nil, tags: Dictionary<String, String>? = nil, fingerprint: [String]? = nil, user: SentryUser? = nil, sdk: SentrySDK?, exception: [SentryException]? = nil) {
        self.eventId = eventId
        self.timestamp = timestamp
        self.logentry = logentry
        self.level = level
        self.platform = platform
        self.logger = logger
        self.serverName = serverName
        self.release = release
        self.environment = environment
        self.modules = modules
        self.extra = extra
        self.tags = tags
        self.fingerprint = fingerprint
        self.user = user
        self.sdk = sdk
        self.exception = exception
    }
}
