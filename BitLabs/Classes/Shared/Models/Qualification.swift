//
//  Qualification.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct Qualification: Decodable {
    let networkId: Int
    let questionId: String
    let country: String
    let language: String
    let question: Question
    let isStandardProfile: Bool
    let isStartBonus: Bool
    let score: Double
    let sequence: Int
}
