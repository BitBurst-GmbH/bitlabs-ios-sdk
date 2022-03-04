//
//  BitLabsAPI.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

/// A class to manage connection with the BitLabs API.
class BitLabsAPI {

	private let token: String
	private let userId: String
	private let decoder = JSONDecoder()
	
	init(_ token: String, _ userId: String) {
		self.token = token
		self.userId = userId
		decoder.keyDecodingStrategy = .convertFromSnakeCase
	}
	
	/// Checks whether there are available surveys or qualification questions in the backend.
	///
	/// It receives a [CheckSurveysResponse](x-source-tag://CheckSurveysResponse)
	/// - Parameter completion: The closure to when an object is returned.
	/// - Parameter hasSurveys:  True if surveys or qualification questions are found. False otherwise.
	public func checkSurveys(_ completion: @escaping (_ hasSurveys: Bool) -> ()) {
		AF.request(BitLabsRouter.checkSurveys(""), interceptor: BitLabsRequestInterceptor(token, userId))
			.responseDecodable(of: BitLabsResponse.self, decoder: decoder) { response in
				switch response.result {
				case .success(let blResponse):
					if let hasSurveys = blResponse.data?.hasSurveys {
						completion(hasSurveys)
					} else {
						print("[BitLabs] Error: \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
						completion(false)
					}
				case .failure(let error):
					print("[BitLabs] \(error)")
					completion(false)
				}
			}
	}
}