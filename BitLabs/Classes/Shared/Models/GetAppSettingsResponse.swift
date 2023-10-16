//
//  GetAppSettingsResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 22.07.22.
//

import Foundation

struct GetAppSettingsResponse: Codable {
    let visual: Visual
    let offers: Offers
    let currency: Currency
    let promotion: Promotion?
}

struct Offers: Codable {
    let enabled: Bool
}
