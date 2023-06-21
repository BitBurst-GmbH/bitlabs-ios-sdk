//
//  User.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

struct User: Decodable {
    let earningsRaw: Double
    let name: String
    let rank: Int
}
