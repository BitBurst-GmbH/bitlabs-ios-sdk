//
//  Survey.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

@objc public class Survey: NSObject, Codable {
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
    
    @objc init(networkId: Int, id: Int, cpi: String, value: String, loi: Double, remaining: Int, details: Details, rating: Int, link: String, missingQuestions: Int) {
        self.networkId = networkId
        self.id = id
        self.cpi = cpi
        self.value = value
        self.loi = loi
        self.remaining = remaining
        self.details = details
        self.rating = rating
        self.link = link
        self.missingQuestions = missingQuestions
    }

    @objc public func open(parent: UIViewController) {
        BitLabs.shared.launchOfferWall(parent: parent)
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
