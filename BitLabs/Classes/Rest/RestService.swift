//
//  RestService.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import Alamofire
import Foundation
import SwiftyJSON

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
    
    override private init() {
        super.init()
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
    
    public func checkForSurveys(completionHandler: @escaping (Bool)-> ()) {
        var url = Constants.baseURL
        url = url.appendingPathComponent("check")
        
        var components = URLComponents(string: url.absoluteString)!
        let platformCurrent = determinePlatform()
        let query = URLQueryItem(name: "platform", value: platformCurrent.rawValue)
        
        components.queryItems = [query]
        let checkSurveyURL = components.url!
        let headers = assembleHeaders(appToken: token, userId: userId)

        struct DecodableType: Decodable { let url: String }
        
        AF.request( checkSurveyURL, headers: headers)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: DecodableType.self) { response in
             switch response.result {
                case .success:
                    let data = response.data!
                    let jsonData = self.decodeResponse(json: data)
                    switch jsonData {
                        case .success(let dataDict):
                            let entity = CheckSurveyReponse.buildFromJSON(json: dataDict)
                            completionHandler(entity.hasSurveys)
                        case .failure(_):
                            completionHandler(false)
                    }
                case .failure(_):
                    completionHandler(false)
                }
        }
    }
}



extension RestService {
    
    func determinePlatform() -> Platform {
        let currentDevice = UIDevice.current
        switch currentDevice.userInterfaceIdiom {
        case .pad:
            return .TABLET
        case .phone:
            return .MOBILE
        default:
            return .MOBILE
        }
    }
    
    
    func decodeResponse(json: Data) -> Result<Dictionary<String,JSON>, BitLabsError> {

        do {
            let responseJSON = try JSON(data: json)
            
            let statusCodeResult = checkStatusCode(json: responseJSON)
            switch statusCodeResult {
            case .failure(let error):
                let r: Result<Dictionary<String,JSON>, BitLabsError> = .failure(error as! BitLabsError)
            return r
            case .success(let code):
                debugPrint("Status code is: \(code.rawValue)")
            }

            guard let _ = responseJSON["data"].dictionary else {
                let error = BitLabsError.MissingResponseData
                let result: Result<Dictionary<String,JSON>,BitLabsError> = .failure(error)
                return result
            }

            let jsonData = responseJSON["data"].dictionary
            let result: Result<Dictionary<String,JSON>,BitLabsError> = .success(jsonData!)
            return result

        } catch {
            let encodedString = json.base64EncodedString()
            let error = BitLabsError.InconsitentJSON(encodedString)
            let result: Result<Dictionary<String,JSON>,BitLabsError> = .failure(error)
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



