//
//  BitLabsResponse.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation

/// This struct is most likely used in all API repsonses in BitLabs API
struct BitLabsResponse: Decodable {
	let data: CheckSurveysResponse?
	let error: ErrorResponse?
	let status: String
	let traceId: String
}

/// - Tag: CheckSurveysResponse
struct CheckSurveysResponse: Decodable {
	let hasSurveys: Bool
}

struct ErrorResponse: Decodable {
	let details: Details
}

struct Details: Decodable {
	let http: String
	let msg: String
}

