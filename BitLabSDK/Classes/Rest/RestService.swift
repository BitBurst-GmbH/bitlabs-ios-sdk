//
//  RestService.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.11.20.
//

import Alamofire
import Foundation
import SwiftyJSON


public typealias checkSurveyResponseHandler = (Result<CheckSurveyReponse,Error>) -> Void
public typealias retrieveSettingsResponseHandler = (Result<RetrieveSettingsResponse,Error>) -> Void

public enum Platform: String, CaseIterable {
    case MOBILE = "MOBILE"
    case TABLET = "TABLET"
}


public class RestService {
    
    public enum Constants {
        public static let baseURL = URL(string: "https://api.bitlabs.ai/v1/client")!
        public static let urlCheckSurveys = "https://api.bitlabs.ai/v1/client?platform=%1"
        public static let retrieveSettingsURL = URL(string: "https://api.bitlabs.ai/v1/client/settings")!
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"

    }
    
    var token: String = ""
    var userId: String = ""
    
    
    public static func Init(token: String, uid: String) ->  RestService{
        let this = RestService(appToken: token, uid: uid)
        return this
    }
    
    private init(appToken: String, uid: String) {
        token = appToken
        userId = uid
    }
    
    private init() {
        
    }
    
    public func retrieveSettings(completion: retrieveSettingsResponseHandler) {
        
        let headers = assembleHeaders(appToken: token, userId: userId)
    }
    
    
    public func checkForSurveys(forPlatform p:Platform, completion: @escaping checkSurveyResponseHandler ) {
        let completionHandler = completion
        var url = Constants.baseURL
        url = url.appendingPathComponent("check")
        
        var components = URLComponents(string: url.absoluteString)!
        let query = URLQueryItem(name: "platform", value: p.rawValue)
        
        components.queryItems = [query]
        let checkSurveyURL = components.url!
        let headers = assembleHeaders(appToken: token, userId: userId)

        AF.request( checkSurveyURL, headers: headers)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
             switch response.result {
                case .success:
                    let data = response.data!
                    let jsonData = self.decodeCheckSurveyResponse(json: data)
                    switch jsonData {
                        case .success(let dataDict):
                            let entity = CheckSurveyReponse.buildFromJSON(json: dataDict)
                            let result: Result<CheckSurveyReponse, Error> = .success(entity)
                            completionHandler(result)
                        case .failure(let error):
                            let result: Result<CheckSurveyReponse, Error> = .failure(error)
                            completionHandler(result)
                            //
                    }
                case .failure(let error):
                    let result: Result<CheckSurveyReponse, Error> = .failure(error)
                    completionHandler(result)
                }
        }
    }
}



extension RestService {

    func decodeCheckSurveyResponse(json: Data) -> Result<Dictionary<String,JSON>, BitlabError> {

        do {
            let responseJSON = try JSON(data: json)
            guard let statusCode = responseJSON["status"].string else {
                let error = BitlabError.MissingStatusCodeInResponse
                let result: Result<Dictionary<String,JSON>,BitlabError> = .failure(error)
                return result
            }

            if statusCode != "success" {
                let error = BitlabError.InvalidStatusCode(statusCode)
                let result: Result<Dictionary<String,JSON>,BitlabError> = .failure(error)
                return result
            }

            guard let _ = responseJSON["data"].dictionary else {
                let error = BitlabError.MissingResponseData
                let result: Result<Dictionary<String,JSON>,BitlabError> = .failure(error)
                return result
            }

            let jsonData = responseJSON["data"].dictionary
            let result: Result<Dictionary<String,JSON>,BitlabError> = .success(jsonData!)
            return result

        } catch {
            let encodedString = json.base64EncodedString()
            let error = BitlabError.InconsitentJSON(encodedString)
            let result: Result<Dictionary<String,JSON>,BitlabError> = .failure(error)
            return result

        }

    }

    func assembleHeaders(appToken: String, userId: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        headers[Constants.apiTokenHeader] = appToken
        headers[Constants.userIdHeader] = userId
        
        return headers
    }
    
}


