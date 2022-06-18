//
//  Details.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

@objc class Details: NSObject, Codable {
    let category: Category
    
    @objc init(category: Category) {
        self.category = category
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
