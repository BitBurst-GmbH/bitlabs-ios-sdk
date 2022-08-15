//
//  Survey.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

public struct Survey: Codable {
    public let networkId: Int
    public let id: Int
    public let cpi: String
    public let value: String
    public let loi: Double
    public let remaining: Int
    public let details: Details
    public let rating: Int
    public let link: String
    public let missingQuestions: Int?
    
    
    public func open(parent: UIViewController) {
        BitLabs.shared.launchOfferWall(parent: parent)
    }
}
