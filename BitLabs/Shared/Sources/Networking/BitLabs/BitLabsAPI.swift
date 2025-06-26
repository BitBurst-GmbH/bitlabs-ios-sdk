//
//  BitLabsAPI.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation

/// A class to manage connection with the BitLabs API.
class BitLabsAPI {
    private let decoder = JSONDecoder()
    
    private let session: URLSession
    
    init(_ session: URLSession) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = session
    }
    
    /// This request reports the termination of a survey with a reason given by the user.
    ///
    /// This endpoint is optional but it is important to use it as source for feedback in real-time to filter out bad surveys to improve the overall UX for all users.
    /// - Parameters:
    ///   - clickId: The click id of the terminated Survey.
    ///   - reason: The reason given by the user. See [LeaveReason](x-source-tag://LeaveReason).
    ///   - completion: The closure to execute after a response for this request is received.
    func leaveSurvey(clickId: String, reason: LeaveReason, completion: @escaping () -> ()) {
        session
            .request(BitLabsRouter.updateClick(clickId: clickId, reason: reason).asURLRequest())
            .responseDecodable(of: BitLabsResponse<UpdateClickResponse>.self, decoder: decoder) { result in
                switch result {
                case .success(let blResponse):
                    if blResponse.status == "success" {
                        print("[BitLabs] Left survey successfully.")
                        completion()
                    } else {
                        let errString = "[BitLabs] Leave Survey \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")"
                        print(errString)
                        SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                        completion()
                    }
                case .failure(let error):
                    let errString = "[BitLabs] Leave Survey Failure: \(error)"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                    completion()
                }
            }
    }
    
    func getSurveys(sdk: String, _ completion: @escaping (Result<[Survey], Error>) -> ()) {
        let request = BitLabsRouter.getSurveys(sdk: sdk).asURLRequest()
        
        session
            .request(request)
            .responseDecodable(of: BitLabsResponse<GetSurveysResponse>.self, decoder: decoder) { result in
                switch result {
                case .success(let blResponse):
                    if let restriction = blResponse.data?.restrictionReason {
                        let exception = Exception(restriction.prettyPrint())
                        SentryManager.shared.captureException(error: exception, stacktrace: Thread.callStackSymbols)
                        completion(.failure(exception))
                        return
                    }
                    
                    
                    if let surveys = blResponse.data?.surveys {
                        completion(.success(surveys))
                        return
                    }
                    
                    let exception = Exception("\(blResponse.error!.details.http) - \(blResponse.error!.details.msg)")
                    SentryManager.shared.captureException(error: exception, stacktrace: Thread.callStackSymbols)
                    completion(.failure(exception))
                    
                case .failure(let error):
                    SentryManager.shared.captureException(error: error, stacktrace: Thread.callStackSymbols)
                    completion(.failure(error))
                }
            }
    }
    
    func getAppSettings(token: String, _ completion: @escaping ([Configuration]) -> ()) {
        let url = URL(string: "https://dashboard.bitlabs.ai/api/public/v1/apps/\(token)")!
        URLSession.shared
            .request(URLRequest(url: url))
            .responseDecodable(of: GetAppSettingsResponse.self, decoder: decoder) { result in
                switch result {
                case .success(let blResponse):
                    completion(blResponse.configuration)
                    
                case .failure(let error):
                    let errString = "[BitLabs] Get App Settings Failure: \(error)"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                }
            }
    }
}

extension URLSession {
    func request(_ request: URLRequest) -> BLSessionRequest {
        return BLSessionRequest(session: self, request: request)
    }
}
