//
//  Reward.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

@objc class Reward: NSObject, Codable {
    let rank: Int
    let rewardRaw: Double
    
    @objc init(rank: Int, rewardRaw: Double) {
        self.rank = rank
        self.rewardRaw = rewardRaw
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
