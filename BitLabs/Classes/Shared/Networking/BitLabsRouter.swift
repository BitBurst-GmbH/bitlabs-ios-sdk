//
//  BitLabsRouter.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

enum BitLabsRouter {
	case checkSurveys
	case leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason)
    case getSurveys(sdk: String)
    case getOffers
    case getAppSettings
    case getLeaderboard
	
	private var baseURL: String {
		return "https://api.bitlabs.ai"
	}
	
	private var path: String {
		switch self {
		case .checkSurveys:
			return "v1/client/check"
		case .leaveSurvey(let networkId, let surveyId, _):
			return "v1/client/networks/\(networkId)/surveys/\(surveyId)/leave"
        case .getSurveys:
            return "v2/client/surveys"
        case .getOffers:
            return "v1/client/offers"
        case .getAppSettings:
            return "v1/client/settings/v2"
        case .getLeaderboard:
            return "v1/client/leaderboard"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .checkSurveys: return .get
		case .leaveSurvey: return .post
        case .getSurveys: return .get
        case .getOffers: return .get
        case .getAppSettings: return .get
        case .getLeaderboard: return .get
		}
	}
	
	var parameters: [String: String] {
		switch self {
		case .checkSurveys:
			return ["platform": getPlatform()]
		case .leaveSurvey(_,_, let reason):
			return ["reason": reason.rawValue]
        case .getSurveys(let sdk):
            return ["platform": getPlatform(), "os": "ios", "sdk": sdk]
        case .getOffers:
            return ["platform": getPlatform()]
        case .getAppSettings:
            return ["platform": getPlatform()]
        case .getLeaderboard:
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
