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
public typealias leaveSurveyResponseHandler = () -> Void


let leaveReasonCodes: Dictionary<LeaveReason, String> = [ .tooSensitive: "SENSITIVE" ,
                                                          .uninteresting: "UNINTERESTING" ,
                                                          .technical: "TECHNICAL" ,
                                                          .tooLong: "TOO_LONG" ,
                                                          .otherReasons: "OTHER"]


public enum Platform: String, CaseIterable {
    case MOBILE = "MOBILE"
    case TABLET = "TABLET"
}


public class RestService: BaseRestService {
    
    public enum Constants {
        public static let baseURL = URL(string: "https://api.bitlabs.ai/v1/client")!
        public static let urlCheckSurveys = "https://api.bitlabs.ai/v1/client?platform=%1"
        public static let retrieveSettingsURL = URL(string: "https://api.bitlabs.ai/v1/client/settings")!
        public static let leaveSurveyReasonURLString = String("https://api.bitlabs.ai/v1/client/networks/{NETWORK_ID}/surveys/{SURVEY_ID}/leave")
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"

    }
    
    var token: String = ""
    var userId: String = ""
    
    var visual = Visual()
    
    
    static func Init(token: String, uid: String) ->  RestService{
        let this = RestService(appToken: token, uid: uid)
        this.retrieveSettings{ result in
            switch result {
            case .success(let data):
                this.visual = data.visual
            case .failure(let error):
                debugPrint("| Error quering settings: \(error.localizedDescription)")
                this.visual = Visual()
            }
        }
        return this
    }
    
    private init(appToken: String, uid: String) {
        token = appToken
        userId = uid
    }
    
    override private init() {
        super.init()
    }
       
    public func retrieveSettings(completion: @escaping retrieveSettingsResponseHandler) {
        let completionHandler = completion
        let headers = assembleHeaders(appToken: token, userId: userId)
    
        AF.request( Constants.retrieveSettingsURL, headers: headers)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                   case .success:
                       let data = response.data!
                       let jsonData = self.decodeResponse(json: data)
                       switch jsonData {
                           case .success(let dataDict):
                               let entity = RetrieveSettingsResponse.buildFromJSON(json: dataDict)
                               let result: Result<RetrieveSettingsResponse, Error> = .success(entity)
                               completionHandler(result)
                           case .failure(let error):
                               let result: Result<RetrieveSettingsResponse, Error> = .failure(error)
                               completionHandler(result)
                       }
                   case .failure(let error):
                       let result: Result<RetrieveSettingsResponse, Error> = .failure(error)
                       completionHandler(result)
                   }

            }
    
    
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
                    debugPrint(data as Any)
                    completion()
                case .failure(let error):
                    debugPrint(error)
                    completion()
                }
            }
    
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
                    let jsonData = self.decodeResponse(json: data)
                    switch jsonData {
                        case .success(let dataDict):
                            let entity = CheckSurveyReponse.buildFromJSON(json: dataDict)
                            let result: Result<CheckSurveyReponse, Error> = .success(entity)
                            completionHandler(result)
                        case .failure(let error):
                            let result: Result<CheckSurveyReponse, Error> = .failure(error)
                            completionHandler(result)
                    }
                case .failure(let error):
                    let result: Result<CheckSurveyReponse, Error> = .failure(error)
                    completionHandler(result)
                }
        }
    }
}



extension RestService {
    
    func decodeResponse(json: Data) -> Result<Dictionary<String,JSON>, BitlabError> {

        do {
            let responseJSON = try JSON(data: json)
            
            let statusCodeResult = checkStatusCode(json: responseJSON)
            switch statusCodeResult {
            case .failure(let error):
                let r: Result<Dictionary<String,JSON>, BitlabError> = .failure(error as! BitlabError)
            return r
            case .success(let code):
                debugPrint("Status code is: \(code.rawValue)")
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


