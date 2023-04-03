//
//  Currency.swift
//  BitLabs
//
//  Created by Omar Raad on 03.04.23.
//

import Foundation

struct Currency: Decodable {
    let floorDecimal: Bool
    let factor: String
    let symbol: Symbol
    let currencyPromotion: Int?
    let bonusPercentage: Int
}
