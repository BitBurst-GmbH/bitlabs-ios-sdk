//
//  BitLabsRouter.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

enum BitLabsRouter {
	case checkSurveys(_ fingerprint: String = "")
	
	private var baseURL: String {
		return "https://api.bitlabs.ai/v1/client"
	}
	
	private var path: String {
		switch self {
		case .checkSurveys:
			return "check"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .checkSurveys:
			return .get
		}
	}
	
	var parameters: Parameters {
		switch self {
		case .checkSurveys(let fingerprint):
			return ["platform": "MOBILE", "sc_fingerprint": fingerprint]
		}
	}
}

// MARK: - URLRequestConvertible
extension BitLabsRouter: URLRequestConvertible {
	func asURLRequest() throws -> URLRequest {
		let url = try baseURL.asURL().appendingPathComponent(path)
		var request = URLRequest(url: url)
		request.method = method
		
		request = try URLEncoding(destination: .methodDependent).encode(request, with: parameters)
	
		return request
	}
}
