//
//  Currency.swift
//  BitLabs
//
//  Created by Omar Raad on 03.04.23.
//

import Foundation

@objc class Currency: NSObject, Codable {
    let floorDecimal: Bool
    let factor: String
    let symbol: Symbol
    let currencyPromotion: Int?
    let bonusPercentage: Int
    
    @objc init(floorDecimal: Bool, factor: String, symbol: Symbol, currencyPromotion: Int, bonusPercentage: Int) {
        self.floorDecimal = floorDecimal
        self.factor = factor
        self.symbol = symbol
        self.currencyPromotion = currencyPromotion
        self.bonusPercentage = bonusPercentage
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
