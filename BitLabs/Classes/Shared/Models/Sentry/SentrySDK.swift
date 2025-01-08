//
//  SentrySDK.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentrySDK: Encodable {
    let name: String
    let version: String
    
    init(name: String = "bitlabs.swift.ios", version: String) {
        self.name = name
        self.version = version
    }
}
