//
//  ResponseModels.swift
//  BitLabSDK
//
//  Created by Frank Marx on 10.11.20.
//

import Foundation
import Alamofire


public struct CheckSurveyReponse : Decodable {
    public var hasSurveys: Bool
    public var traceId: String
    
    public init() {
        hasSurveys = false
        traceId = ""
    }
    
}
