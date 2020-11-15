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

public struct Currency {
    public var format: String
    public var exchangeFactor: Double
    public var iconURL: String
}

public struct Visual {
    public var colorDark: UIColor
    public var colorLight: UIColor
    public var colorAccent: UIColor
    
    init() {
        colorDark = UIColor(named: Colors.colorDark.rawValue)!
        colorLight = UIColor(named: Colors.colorLight.rawValue)!
        colorAccent = UIColor(named: Colors.colorAccent.rawValue)!
    }
    
}


public struct RetrieveSettingsResponse {
    public var visual: Visual
    public var currency: Currency
}
