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
    let iconName: String
    let nameInternal: String
    
    @objc init(name: String, iconUrl: String, iconName: String, nameInternal: String) {
        self.name = name
        self.iconUrl = iconUrl
        self.iconName = iconName
        self.nameInternal = nameInternal
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
