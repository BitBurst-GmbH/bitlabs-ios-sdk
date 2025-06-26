//
//  Symbol.swift
//  BitLabs
//
//  Created by Omar Raad on 03.04.23.
//

import Foundation

@objc class Symbol: NSObject, Codable {
    let content: String
    let isImage: Bool
    
    @objc init(content: String, isImage: Bool) {
        self.content = content
        self.isImage = isImage
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
