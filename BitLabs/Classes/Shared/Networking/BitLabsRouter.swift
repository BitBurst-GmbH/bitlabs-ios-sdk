//
//  BitLabsRouter.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

enum BitLabsRouter {
	case updateClick(clickId: String, reason: LeaveReason)
    case getSurveys(sdk: String)
    case getOffers
    case getAppSettings
    case getLeaderboard
	
	private var baseURL: String {
		return "https://api.bitlabs.ai"
	}
	
	private var path: String {
		switch self {
        case .updateClick(let clickId, _):
			return "v2/client/clicks/\(clickId)"
        case .getSurveys:
            return "v2/client/surveys"
        case .getOffers:
            return "v2/client/offers"
        case .getAppSettings:
            return "v1/client/settings/v2"
        case .getLeaderboard:
            return "v1/client/leaderboard"
		}
	}
	
	var method: HTTPMethod {
        switch self {
		case .updateClick: return .post
        case .getSurveys: return .get
        case .getOffers: return .get
        case .getAppSettings: return .get
        case .getLeaderboard: return .get
		}
	}
	
	var parameters: Parameters {
		switch self {
		case .updateClick(_, let reason):
            return ["leave_survey": ["reason": reason.rawValue]]
        case .getSurveys(let sdk):
            return ["platform": getPlatform(), "os": "ios", "sdk": sdk]
        case .getOffers:
            return ["platform": getPlatform(), "debug": true]
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
            let queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = queryItems
            request.url = urlComponents?.url
            print(request.url)
		} else if method == .post {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
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
