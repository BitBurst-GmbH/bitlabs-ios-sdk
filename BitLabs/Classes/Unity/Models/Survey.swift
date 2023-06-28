//
//  Survey.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

@objc public class Survey: NSObject, Codable {
    let id: String
    let type: String
    let clickUrl: String
    let cpi: String
    let value: String
    let loi: Double
    let country: String
    let language: String
    let rating: Int
    let category: Category
    let tags: [String]
    
    @objc init( id: String, type: String, clickUrl: String, cpi: String, value: String, loi: Double, country: String, language: String, rating: Int, category: Category, tags: [String]) {
        self.id = id
        self.type = type
        self.clickUrl = clickUrl
        self.cpi = cpi
        self.value = value
        self.loi = loi
        self.country = country
        self.language = language
        self.rating = rating
        self.category = category
        self.tags = tags
    }

    @objc public func open(parent: UIViewController) {
        BitLabs.shared.launchOfferWall(parent: parent)
    }
    
    @objc public func asDictionary() -> [String: Any] {
        return toDictionary()
    }
}
