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
    let module: String? = nil
    let stacktrace: SentryStackTrace? = nil
    let mechanism: SentryExceptionMechanism? = SentryExceptionMechanism()
}
