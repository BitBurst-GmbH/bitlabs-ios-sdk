//
//  SentryStackTrace.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryStackTrace: Encodable {
    let frames: [SentryStackFrame]
}
