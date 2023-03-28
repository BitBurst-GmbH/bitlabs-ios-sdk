//
//  GetLeaderboardResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

struct GetLeaderboardResponse: Decodable {
    let nextResetAt: String
    let ownUser: OwnUser?
    let rewards: [Reward]
    let topUsers: [TopUser]?
}
