//
//  TopUser.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

@objc class TopUser: NSObject, Codable {
    let earningsRaw: Double
    let name: String
    let rank: Int
    
    @objc init(earningsRaw: Double, name: String, rank: Int) {
        self.earningsRaw = earningsRaw
        self.name = name
        self.rank = rank
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
