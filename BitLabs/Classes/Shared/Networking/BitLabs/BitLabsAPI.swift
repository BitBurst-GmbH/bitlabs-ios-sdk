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
    private let decoder = JSONDecoder()
    
    private let session: Session
    
    init(_ session: Session) {
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
            .request(BitLabsRouter.updateClick(clickId: clickId, reason: reason))
            .responseDecodable(of: BitLabsResponse<UpdateClickResponse>.self, decoder: decoder) { response in
                switch response.result {
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
        session
            .request(BitLabsRouter.getSurveys(sdk: sdk))
            .responseDecodable(of: BitLabsResponse<GetSurveysResponse>.self, decoder: decoder) { response in
                switch response.result {
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
            }.resume()
    }
    
    func getAppSettings(token: String, _ completion: @escaping ([Configuration]) -> ()) {
        AF.request("https://dashboard.bitlabs.ai/api/public/v1/apps/\(token)")
            .responseDecodable(of: GetAppSettingsResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let blResponse):
                    completion(blResponse.configuration)
                    
                case .failure(let error):
                    let errString = "[BitLabs] Get App Settings Failure: \(error)"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                }
            }
    }
    
    func getLeaderboard(_ completion: @escaping (GetLeaderboardResponse) -> ()) {
        session
            .request(BitLabsRouter.getLeaderboard)
            .responseDecodable(of: BitLabsResponse<GetLeaderboardResponse>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let blResponse):
                    if let data = blResponse.data {
                        completion(data)
                        return
                    }
                    
                    let errString = "[BitLabs] Get Leaderboard \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                    
                case .failure(let error):
                    let errString = "[BitLabs] Get Leaderboard Failure: \(error)"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                }
            }
    }
    
    func getCurrencyIcon(url: String, _ completion: @escaping (UIImage?) -> ()) {
        AF.request(url).responseData { response in
            switch (response.result) {
            case .success(let data):
                guard let mimeType = response.response?.mimeType, mimeType == "image/svg+xml" else {
                    completion(UIImage(data: data))
                    return
                }
                
                guard let image = SVG(data)?.image() else {
                    let errString = "[BitLabs] Failed converting SVG to UIImage"
                    print(errString)
                    SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                    completion(nil)
                    return
                }
                
                completion(image)
                
            case .failure(let error):
                let errString = "[BitLabs] Get Currency Icon Failure: \(error)"
                print(errString)
                SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
                completion(nil)
            }
        }
    }
}
