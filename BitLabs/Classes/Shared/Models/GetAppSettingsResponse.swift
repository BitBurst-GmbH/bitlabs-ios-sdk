//
//  GetAppSettingsResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 22.07.22.
//

import Foundation

struct GetAppSettingsResponse: Decodable {
    let visual: Visual
    let currency: Currency
    let promotion: Promotion?
}
