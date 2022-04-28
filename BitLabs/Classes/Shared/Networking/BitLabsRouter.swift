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
	case leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason)
    case getSurveys
	
	private var baseURL: String {
		return "https://api.bitlabs.ai/v1/client"
	}
	
	private var path: String {
		switch self {
		case .checkSurveys:
			return "check"
		case .leaveSurvey(let networkId, let surveyId, _):
			return "networks/\(networkId)/surveys/\(surveyId)/leave"
        case .getSurveys:
            return "actions"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .checkSurveys:
			return .get
		case .leaveSurvey:
			return .post
        case .getSurveys:
            return .get
		}
	}
	
	var parameters: [String: String] {
		switch self {
		case .checkSurveys(let fingerprint):
			return ["platform": getPlatform(), "sc_fingerprint": fingerprint]
		case .leaveSurvey(_,_, let reason):
			return ["reason": reason.rawValue]
        case .getSurveys:
            return ["platform": getPlatform()]
		}
	}
}

// MARK: - URLRequestConvertible
extension BitLabsRouter: URLRequestConvertible {
	func asURLRequest() throws -> URLRequest {
		let url = try baseURL.asURL().appendingPathComponent(path)
		var request = URLRequest(url: url)
		request.method = method
		
		if method == .get {
			request = try URLEncodedFormParameterEncoder()
				.encode(parameters, into: request)
		} else if method == .post {
			request = try JSONParameterEncoder().encode(parameters, into: request)
			request.setValue("application/json", forHTTPHeaderField: "Accept")
		}
	
		return request
	}
	
	func getPlatform() -> String {
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			return "TABLET"
		default:
			return "MOBILE"
		}
	}
}
