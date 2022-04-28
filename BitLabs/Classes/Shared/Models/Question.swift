//
//  Question.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct Question: Decodable {
    let networkId: Int
    let id: String
    let country: String
    let language: String
    let type: String
    let localizedText: String
    let answers: [Answer]
    let canSkip: Bool
}
