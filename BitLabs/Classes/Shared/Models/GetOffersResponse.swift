//
//  GetOffersResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 02.06.22.
//

import Foundation

struct GetOffersResponse: Decodable {
    let offers: [Offer]
}
