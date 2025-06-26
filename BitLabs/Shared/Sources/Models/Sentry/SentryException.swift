//
//  SentryException.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryException: Encodable {
    let type: String
    let value: String
    let module: String?
    let stacktrace: SentryStackTrace?
    let mechanism: SentryExceptionMechanism?
    
    init(type: String, value: String, module: String? = nil, stacktrace: SentryStackTrace? = nil, mechanism: SentryExceptionMechanism? = SentryExceptionMechanism()) {
        self.type = type
        self.value = value
        self.module = module
        self.stacktrace = stacktrace
        self.mechanism = mechanism
    }
}
