//
//  RestrictionReason.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct RestrictionReason: Codable {
    let notVerified: Bool?
    let usingVpn: Bool?
    let bannedUntil: String?
    let reason: String?
    let unsupportedCountry: String?
}
