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
    
    func prettyPrint() -> String {
        if notVerified == true { return "The publisher account that owns this app has not been verified and therefore cannot receive surveys." }
        if usingVpn == true { return "The user is using a VPN and cannot access surveys." }
        if bannedUntil != nil { return "The user is banned until $bannedUntil" }
        if unsupportedCountry != nil { return "Unsupported Country: $unsupportedCountry" }
        return reason ?? "Unknown Reason"
    }
}
