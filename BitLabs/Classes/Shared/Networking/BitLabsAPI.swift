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
                        print("[BitLabs] Leave Survey \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                        completion()
                    }
                case .failure(let error):
                    print("[BitLabs] Leave Survey Failure: \(error)")
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
                        completion(.failure(Exception(restriction.prettyPrint())))
                        return
                    }
                    
                    
                    if let surveys = blResponse.data?.surveys {
                        completion(.success(surveys))
                        return
                    }
                    
                    completion(.failure(Exception("\(blResponse.error!.details.http) - \(blResponse.error!.details.msg)")))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getAppSettings(_ completion: @escaping (Visual, Currency?, Promotion?) -> ()) {
        session
            .request(BitLabsRouter.getAppSettings)
            .responseDecodable(of: BitLabsResponse<GetAppSettingsResponse>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let blResponse):
                    if let visual = blResponse.data?.visual {
                        completion(visual, blResponse.data?.currency, blResponse.data?.promotion)
                        return
                    }
                    
                    print("[BitLabs] Get App Settings \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                    
                case .failure(let error):
                    print("[BitLabs] Get App Settings Failure: \(error)")
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
                    
                    print("[BitLabs] Get Leaderboard \(blResponse.error?.details.http ?? "Error"): \(blResponse.error?.details.msg ?? "Couldn't retrieve error info... Trace ID: \(blResponse.traceId)")")
                    
                case .failure(let error):
                    print("[BitLabs] Get Leaderboard Failure: \(error)")
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
                    print("[BitLabs] Failed converting SVG to UIImage")
                    completion(nil)
                    return
                }
                
                completion(image)
                
            case .failure(let error):
                print("[BitLabs] Get Currency Icon Failure: \(error)")
                completion(nil)
            }
        }
    }
}
