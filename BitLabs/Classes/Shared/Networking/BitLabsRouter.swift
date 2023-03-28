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
    case getActions
    case getOffers
    case getAppSettings
    case getLeaderboard
	
	private var baseURL: String {
		return "https://api.bitlabs.ai/v1/client"
	}
	
	private var path: String {
		switch self {
		case .checkSurveys:
			return "check"
		case .leaveSurvey(let networkId, let surveyId, _):
			return "networks/\(networkId)/surveys/\(surveyId)/leave"
        case .getActions:
            return "actions"
        case .getOffers:
            return "offers"
        case .getAppSettings:
            return "settings/v2"
        case .getLeaderboard:
            return "leaderboard"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .checkSurveys: return .get
		case .leaveSurvey: return .post
        case .getActions: return .get
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
        case .getActions:
            return ["platform": getPlatform()]
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
