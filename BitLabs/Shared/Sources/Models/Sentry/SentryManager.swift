//
//  SentryManager.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

package class SentryManager {
    package static let shared = SentryManager()
    
    private init() {}
    
    private var sentryService: SentryService?
    
    package func configure(token: String, uid: String, dsnStr: String) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return }
        let dsn = SentryDSN(dsnStr)
        
        self.sentryService = SentryService(token, uid, dsn)
    }
    
    package func captureException(error: Error, stacktrace: [String], isHandled: Bool = true) {
        sentryService?.sendEnvelope(withError: error, in: stacktrace, isHandled: isHandled)
    }
}
