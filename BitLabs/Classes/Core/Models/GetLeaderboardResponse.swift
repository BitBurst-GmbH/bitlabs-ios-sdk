//
//  GetLeaderboardResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

struct GetLeaderboardResponse: Codable {
    let nextResetAt: String
    let ownUser: User?
    let rewards: [Reward]
    let topUsers: [User]?
}
