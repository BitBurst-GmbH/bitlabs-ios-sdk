//
//  Survey.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

public struct Survey: Decodable {
    let networkId: Int
    let id: Int
    let cpi: String
    let value: String
    let loi: Double
    let remaining: Int
    let details: Details
    let rating: Int
    let link: String
    let missingQuestions: Int?
    
    
    public func open(parent: UIViewController) {
        BitLabs.shared.launchOfferWall(parent: parent)
    }
}
