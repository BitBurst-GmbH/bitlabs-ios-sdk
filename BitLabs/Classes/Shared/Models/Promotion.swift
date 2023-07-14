//
//  Promotion.swift
//  BitLabs
//
//  Created by Omar Raad on 13.07.23.
//

import Foundation

struct Promotion: Decodable {
    let startDate: String
    let endDate: String
    let bonusPercentage: Int
}
