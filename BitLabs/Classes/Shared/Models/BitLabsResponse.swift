//
//  BitLabsResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation

/// This struct is most likely used in all API repsonses in BitLabs API
struct BitLabsResponse<T: Decodable>: Decodable {
	let data: T?
	let error: ErrorResponse?
	let status: String
	let traceId: String
}

