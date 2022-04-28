//
//  ErrorDetails.swift
//  BitLabs
//
//  Created by Omar Raad on 28.04.22.
//

import Foundation

struct ErrorDetails: Decodable {
    let http: String
    let msg: String
}
