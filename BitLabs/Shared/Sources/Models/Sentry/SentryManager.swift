//
//  SentryManager.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

class SentryManager {
    static let shared = SentryManager()
    
    private init() {}
    
    private var sentryService: SentryService?
    
    func configure(token: String, uid: String, dsnStr: String) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return }
        let dsn = SentryDSN(dsnStr)
        
        self.sentryService = SentryService(token, uid, dsn)
    }
    
    func captureException(error: Error, stacktrace: [String], isHandled: Bool = true) {
        sentryService?.sendEnvelope(withError: error, in: stacktrace, isHandled: isHandled)
    }
}
