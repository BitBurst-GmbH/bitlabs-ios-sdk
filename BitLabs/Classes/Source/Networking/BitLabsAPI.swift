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
	
	private let session: Session
	
	init(_ token: String, _ userId: String) {
		self.token = token
		self.userId = userId
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		session = Session(interceptor: BitLabsRequestInterceptor(token, userId))
	}
	
	/// Checks whether there are available surveys or qualification questions in the backend.
	///
	/// It receives a [CheckSurveysResponse](x-source-tag://CheckSurveysResponse)
	/// - Parameter completion: The closure to when an object is returned.
	/// - Parameter hasSurveys:  True if surveys or qualification questions are found. False otherwise.
	public func checkSurveys(_ completion: @escaping (_ hasSurveys: Bool) -> ()) {
		session.request(BitLabsRouter.checkSurveys(""))
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
	
	func leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason, completion: @escaping (Bool) -> ()) {
		session.request(BitLabsRouter.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason)).responseDecodable(of: BitLabsResponse.self, decoder: decoder) { response in
			switch response.result {
			case .success(let blResponse):
				if blResponse.status == "success" {
					print("[BitLabs] Left survey successfully.")
					completion(true)
				} else {
					print("[BitLabs] Error: \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
					completion(false)
				}
			case .failure(let error):
				print("[BitLabs] Technical \(error.errorDescription ?? "")")
				completion(false)
			}
		}
	}
}
