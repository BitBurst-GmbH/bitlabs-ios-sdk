//
//  Survey.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import UIKit

public struct Survey: Codable {
    public let id: String
    public let type: String
    public let clickUrl: String
    public let cpi: String
    public let value: String
    public let loi: Double
    public let country: String
    public let language: String
    public let rating: Int
    public let category: Category
    public let tags: [String]
    
    public func open(parent: UIViewController) {
        BitLabs.shared.launchOfferWall(parent: parent)
    }
}
