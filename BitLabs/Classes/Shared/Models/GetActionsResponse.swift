//
//  GetActionsResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct GetActionsResponse: Decodable {
    let isNewUser: Bool
    let startBonus: StartBonus?
    let restrictionReason: RestrictionReason?
    let surveys: [Survey]
    let qualification: Qualification?
}
