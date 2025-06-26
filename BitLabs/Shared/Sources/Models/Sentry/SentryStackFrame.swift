//
//  SentryStackFrame.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryStackFrame: Encodable {
    let filename: String?
    let function: String?
    let module: String?
    let lineno: Int?
    let colno: Int?
    let absPath: String?
    let contextLine: String?
    let preContext: [String]?
    let postContext: [String]?
    let inApp: Bool?
    
    init(filename: String? = nil, function: String? = nil, module: String? = nil, lineno: Int? = nil, colno: Int? = nil, absPath: String? = nil, contextLine: String? = nil, preContext: [String]? = nil, postContext: [String]? = nil, inApp: Bool? = nil) {
        self.filename = filename
        self.function = function
        self.module = module
        self.lineno = lineno
        self.colno = colno
        self.absPath = absPath
        self.contextLine = contextLine
        self.preContext = preContext
        self.postContext = postContext
        self.inApp = inApp
    }
}
