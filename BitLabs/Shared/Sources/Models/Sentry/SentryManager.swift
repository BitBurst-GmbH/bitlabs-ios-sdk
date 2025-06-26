//
//  SentryManager.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

class SentryManager {
    static let shared = SentryManager()
    
    let dsn: SentryDSN
    
    var url: String
    var publicKey: String
    var projectID: String
    
    private var host: String
    private var scheme: String
    private var sentryService: SentryService? = nil
    
    private init() {
        self.dsn = SentryDSN(SubspecConfig.DSN)
        
        self.host = dsn.host
        self.scheme = dsn.scheme
        self.projectID = dsn.projectID
        self.publicKey = dsn.publicKey
        self.url = "\(scheme)://\(host)/"
    }
    
    func configure(token: String, uid: String) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return
        }
        self.sentryService = SentryService(token, uid)
    }
    
    func captureException(error: Error, stacktrace: [String], isHandled: Bool = true) {
        sentryService?.sendEnvelope(withError: error, in: stacktrace, isHandled: isHandled)
    }
}
