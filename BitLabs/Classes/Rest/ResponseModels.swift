//
//  ResponseModels.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit
import SwiftyJSON



public struct CheckSurveyReponse {
    public var hasSurveys: Bool

    static func buildFromJSON(json: Dictionary<String,JSON>) -> CheckSurveyReponse {
        var this = CheckSurveyReponse()
        guard let hasSurveys = json["has_surveys"]?.bool else {
            this.hasSurveys = false
            return this
        }
        this.hasSurveys = hasSurveys
        return this
    }
    
    init() {
        hasSurveys = false
    }
    
}

struct LeaveReasonData {
    var reason: String
}
