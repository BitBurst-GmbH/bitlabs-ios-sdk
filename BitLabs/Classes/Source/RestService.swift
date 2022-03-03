//
//  RestService.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import Alamofire
import Foundation


public typealias leaveSurveyResponseHandler = () -> Void


let leaveReasonCodes: Dictionary<LeaveReason, String> = [ .tooSensitive: "SENSITIVE" ,
                                                          .uninteresting: "UNINTERESTING" ,
                                                          .technical: "TECHNICAL" ,
                                                          .tooLong: "TOO_LONG" ,
                                                          .otherReasons: "OTHER"]


public class RestService {
    
    public enum Constants {
        public static let baseURL = URL(string: "https://api.bitlabs.ai/v1/client")!
        public static let urlCheckSurveys = "https://api.bitlabs.ai/v1/client?platform=%1"
        public static let leaveSurveyReasonURLString = String("https://api.bitlabs.ai/v1/client/networks/{NETWORK_ID}/surveys/{SURVEY_ID}/leave")
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"

    }
    
    var token: String = ""
    var userId: String = ""

    
    static func Init(token: String, uid: String) ->  RestService{
        return RestService(appToken: token, uid: uid)
    }
    
    private init(appToken: String, uid: String) {
        token = appToken
        userId = uid
    }

    func leaveSurvey( networkId: String, surveyId: String, reason: LeaveReason, completion: @escaping leaveSurveyResponseHandler) {
        var urlString = Constants.leaveSurveyReasonURLString
        urlString = urlString.replacingOccurrences(of: "{NETWORK_ID}", with: networkId)
        urlString = urlString.replacingOccurrences(of: "{SURVEY_ID}", with: surveyId)
        
        let url = URL(string: urlString)!
        let headers = assembleHeaders(appToken: token, userId: userId)
       
        let leaveReason = leaveReasonCodes[reason]!
        let json: [String: String] = ["reason" : leaveReason]

        AF.request( url, method: .post , parameters: json, encoder: JSONParameterEncoder.default, headers: headers)
           .validate(statusCode: 200...200)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    completion()
                case .failure(let error):
                    debugPrint(error)
                    completion()
                }
            }
    
    }
}



extension RestService {
    func assembleHeaders(appToken: String, userId: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        headers[Constants.apiTokenHeader] = appToken
        headers[Constants.userIdHeader] = userId
        
        return headers
    }
}



