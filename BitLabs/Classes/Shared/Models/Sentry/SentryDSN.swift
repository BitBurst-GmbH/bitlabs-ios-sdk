//
//  SentryDSN.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

class SentryDSN {
    var dsn: String = ""
    var host: String = ""
    var scheme: String = ""
    var publicKey: String = ""
    var projectID: String = ""
    
    init(_ dsn: String) {
        self.dsn = dsn
        
        let regex = try? NSRegularExpression(pattern: "(\\w+)://(\\w+)@(.*)/(\\w+)")
        
        guard let match = regex?.firstMatch(in: dsn, range: NSRange(location: 0, length: dsn.utf16.count)) else {
            print("[BitLabs] Invalid DSN: \(dsn), skipping Sentry config.")
            return
        }
        
        let schemeRange = Range(match.range(at: 1), in: dsn)!
        let publicKeyRange = Range(match.range(at: 2), in: dsn)!
        let hostRange = Range(match.range(at: 3), in: dsn)!
        let projectIDRange = Range(match.range(at: 4), in: dsn)!
        
        self.scheme = String(dsn[schemeRange])
        self.publicKey = String(dsn[publicKeyRange])
        self.host = String(dsn[hostRange])
        self.projectID = String(dsn[projectIDRange])
    }
    
    func asString() -> String {
        return dsn
    }
}
