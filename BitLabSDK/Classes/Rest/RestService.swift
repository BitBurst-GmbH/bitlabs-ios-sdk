//
//  RestService.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.11.20.
//

import Alamofire
import Foundation


public typealias checkSurveyResponseHandler = (Result<CheckSurveyReponse,AFError>) -> Void

public enum Platform: String, CaseIterable {
    case MOBILE = "MOBILE"
    case TABLET = "TABLET"
}


public class RestService {
    
    public enum Constants {
        public static let baseURL = URL(string: "https://api.bitlabs.ai/v1/client")!
        public static let urlCheckSurveys = "https://api.bitlabs.ai/v1/client?platform=%1"
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
    
    public func checkForSurveys(forPlatform p:Platform, completion: @escaping                   checkSurveyResponseHandler ) {
        let completionHandler = completion
        var url = Constants.baseURL
        url = url.appendingPathComponent("check")
        
        var components = URLComponents(string: url.absoluteString)!
        let query = URLQueryItem(name: "platform", value: p.rawValue)
        
        components.queryItems = [query]
        let checkSurveyURL = components.url!
        let headers = assembleHeaders(appToken: token, userId: userId)
       
        /*
         Alamofire.request(.GET, "https://httpbin.org/get", headers: headers)
                   .responseJSON { response in
                       debugPrint(response)
                   }
         */
        AF.request( checkSurveyURL, headers: headers)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let dict = data as! Dictionary<String, String>
//                    let entity = self.decodeCheckSurveyResponse(json: data as! Dictionary<String, String>)
   
                    let responseModel = CheckSurveyReponse()
                    let result: Result<CheckSurveyReponse, AFError> = .success(responseModel)
                    completionHandler(result)
                case .failure(let error):
                    let result: Result<CheckSurveyReponse, AFError> = .failure(error)
                    completionHandler(result)
                }
                
            debugPrint(response)
        }

    }
    
    
}



extension RestService {

    func decodeCheckSurveyResponse(json: Data) -> CheckSurveyReponse {
        var entity = CheckSurveyReponse()
        
        let jsonDecoder = JSONDecoder()
        do {
            let e = try jsonDecoder.decode( CheckSurveyReponse.self, from: json)
        } catch let error as Error {
            var i = 2
        }
        
        //                    do {
        //                  //      let jsonDecoder = JSONDecoder()
        //                  //      let entity = try jsonDecoder.decode( CheckSurveyReponse.self, from: data as! Data)
        //                    } catch DecodingError.dataCorrupted(let error) {
        //
        //                    }
        
        
        return entity
    }
    
    
    func assembleHeaders(appToken: String, userId: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        headers[Constants.apiTokenHeader] = appToken
        headers[Constants.userIdHeader] = userId
        
        return headers
    }
    
}


