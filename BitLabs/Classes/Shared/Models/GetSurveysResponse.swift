//
//  GetSurveysResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct GetSurveysResponse: Decodable {
    let restrictionReason: RestrictionReason?
    let surveys: [Survey]
}
