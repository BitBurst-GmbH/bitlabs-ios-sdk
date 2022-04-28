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
    /// - Parameter completion: The closure to execute after a response for this request is received.
    public func checkSurveys(_ completion: @escaping (Bool) -> ()) {
        session
            .request(BitLabsRouter.checkSurveys(""))
            .responseDecodable(of: BitLabsResponse<CheckSurveysResponse>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let blResponse):
                    if let hasSurveys = blResponse.data?.hasSurveys {
                        completion(hasSurveys)
                    } else {
                        print("[BitLabs] Check Surveys \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                        completion(false)
                    }
                case .failure(let error):
                    print("[BitLabs] Failure: \(error)")
                    completion(false)
                }
            }
    }
    
    /// This request reports the termination of a survey with a reason given by the user.
    ///
    /// This endpoint is optional but it is important to use it as source for feedback in real-time to filter out bad surveys to improve the overall UX for all users.
    /// - Parameters:
    ///   - networkId: The ID of the Network this survey belongs to, this is a path component..
    ///   - surveyId: The ID of the terminated Survey, this is a path component.
    ///   - reason: The reason given by the user. See [LeaveReason](x-source-tag://LeaveReason).
    ///   - completion: The closure to execute after a response for this request is received.
    func leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason, completion: @escaping () -> ()) {
        session
            .request(BitLabsRouter.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason))
            .responseDecodable(of: BitLabsResponse<String>.self, decoder: decoder) { response in
            switch response.result {
            case .success(let blResponse):
                if blResponse.status == "success" {
                    print("[BitLabs] Left survey successfully.")
                    completion()
                } else {
                    print("[BitLabs] Leave Survey \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                    completion()
                }
            case .failure(let error):
                print("[BitLabs] Failure: \(error)")
                completion()
            }
        }
    }
    
    func getSurveys(_ completion: @escaping ([Survey]?) -> ()) {
        session
            .request(BitLabsRouter.getSurveys)
            .responseDecodable(of: BitLabsResponse<GetActionsResponse>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let blResponse):
                    if blResponse.status == "success" {
                        completion(blResponse.data?.surveys)
                    } else {
                        print("[BitLabs] Get Surveys \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                        completion(nil)
                    }
                case .failure(let error):
                    print("[BitLabs] Failure: \(error)")
                    completion(nil)
                }
            }
    }
}
