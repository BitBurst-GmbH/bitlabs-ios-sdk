//
//  SentryStackFrame.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryStackFrame: Encodable {
    let filename: String? = nil
    let function: String? = nil
    let module: String? = nil
    let lineno: Int? = nil
    let colno: Int? = nil
    let absPath: String? = nil
    let contextLine: String? = nil
    let preContext: [String]? = nil
    let postContext: [String]? = nil
    let inApp: Bool? = nil
}
