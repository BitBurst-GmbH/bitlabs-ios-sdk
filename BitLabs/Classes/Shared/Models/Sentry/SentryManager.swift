//
//  SentryManager.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation
import Alamofire

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
        self.dsn = SentryDSN("https://6dab398ce6543c556092f90cc8510974@o494432.ingest.us.sentry.io/4508551901806593")
        
        self.host = dsn.host
        self.scheme = dsn.scheme
        self.projectID = dsn.projectID
        self.publicKey = dsn.publicKey
        self.url = "\(scheme)://\(host)/"
    }
    
    func configure(token: String, uid: String) {
        let session = Session()
        self.sentryService = SentryService(session)
    }
    
    func captureException(exception: Exception) {
        print("capturing Exception")
        sentryService?.sendEnvelope(withException: exception)
    }
}
