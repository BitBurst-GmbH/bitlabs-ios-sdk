//
//  ResponseModels.swift
//  BitLabSDK
//
//  Created by Frank Marx on 10.11.20.
//

import Foundation
import SwiftyJSON


public struct CheckSurveyReponse {
    public var hasSurveys: Bool

    static func buildFromJSON(json: Dictionary<String,JSON>) -> CheckSurveyReponse {
        var this = CheckSurveyReponse()
        guard let _ = json["has_surveys"]?.bool else {
            this.hasSurveys = false
            return this
        }
        this.hasSurveys = true
        return this
    }
    init() {
        hasSurveys = false
    }
    
}
