//
//  BitLabsRouter.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation

enum BitLabsRouter {
	case updateClick(clickId: String, reason: LeaveReason)
    case getSurveys(sdk: String)
	
	private var baseURL: String {
		return "https://api.bitlabs.ai"
	}
	
	private var path: String {
		switch self {
        case .updateClick(let clickId, _):
			return "v2/client/clicks/\(clickId)"
        case .getSurveys:
            return "v2/client/surveys"
		}
	}
	
	var method: String {
        switch self {
		case .updateClick: return "POST"
        case .getSurveys: return "GET"
		}
	}
	
    var parameters: [String: Any] {
		switch self {
		case .updateClick(_, let reason):
            return ["leave_survey": ["reason": reason.rawValue]]
        case .getSurveys(let sdk):
            return ["platform": getPlatform(), "os": "ios", "sdk": sdk]
		}
	}
    
    func asURLRequest() -> URLRequest {
        let url = URL(string: baseURL)!.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
                
        if method == "GET" {
            let queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = queryItems
            request.url = urlComponents?.url
        } else if method == "POST" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
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
