//
//  Category.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

@objc class Category: NSObject, Codable {
    let name: String
    let iconUrl: String
    
    init(name: String, iconUrl: String) {
        self.name = name
        self.iconUrl = iconUrl
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
