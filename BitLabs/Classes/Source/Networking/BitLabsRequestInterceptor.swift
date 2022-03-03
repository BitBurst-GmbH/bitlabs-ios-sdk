//
//  BitLabsRequestInterceptor.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

class BitLabsRequestInterceptor: RequestInterceptor {
	
	private let token: String
	private let userId: String
	
	init(_ token: String, _ userId: String) {
		self.token = token
		self.userId = userId
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var request = urlRequest
		
		request.setValue(token, forHTTPHeaderField: "X-Api-Token")
		request.setValue(userId, forHTTPHeaderField: "X-User-Id")
		
		completion(.success(request))
	}
}
