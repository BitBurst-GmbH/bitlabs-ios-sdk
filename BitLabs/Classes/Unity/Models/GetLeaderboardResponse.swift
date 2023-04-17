//
//  GetLeaderboardResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 16.04.23.
//

import Foundation

@objc public class GetLeaderboardResponse: NSObject, Codable {
    let nextResetAt: String
    let ownUser: OwnUser?
    let rewards: [Reward]
    let topUsers: [TopUser]?
    
    @objc init(nextResetAt: String, ownUser: OwnUser?, rewards: [Reward], topUsers: [TopUser]?) {
        self.nextResetAt = nextResetAt
        self.ownUser = ownUser
        self.rewards = rewards
        self.topUsers = topUsers
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
