//
//  ResponseModels.swift
//  BitLabSDK
//
//  Created by Frank Marx on 10.11.20.
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

public struct Currency {
    public var format: String
    public var exchangeFactor: String
    public var iconURL: String
    
}

public struct Visual {
    public var colorDark: UIColor
    public var colorLight: UIColor
    public var colorAccent: UIColor
    
    init() {
        colorDark = UIColor(hex: "#000000ff")!
        colorLight = UIColor(hex: "#ffee88ff")!
        colorAccent = UIColor(hex: "#aa4488ff")!
    }
    
    init( colorDark: UIColor, colorLight: UIColor, colorAccent: UIColor) {
        self.colorDark = colorDark
        self.colorLight = colorLight
        self.colorAccent = colorAccent
    }
    
}


public struct RetrieveSettingsResponse {
    public var visual: Visual
    public var currency: Currency? = nil
    
    static func buildFromJSON(json: Dictionary<String,JSON>) -> RetrieveSettingsResponse {
        var this = RetrieveSettingsResponse()
        guard let visual = json["visual"]?.dictionary else {
            this.visual = Visual()
            return this
        }
        
        guard let currency = json["currency"]?.dictionary else {
            this.visual = Visual()
            return this
        }
        
        this.visual = this.buildVisual(json: visual)
        this.currency = this.buildCurrency(json: currency)
        return this
    }
    
    func buildCurrency(json: Dictionary<String,JSON>) -> Currency {
        let format = json["format"]!.string!
        let exchangeFactor = json["exchange_factor"]!.string!
        let iconURL = json["icon_url"]!.string!
        let currency = Currency(format: format, exchangeFactor: exchangeFactor, iconURL: iconURL)
        return currency
    }
    
    
    func buildVisual(json: Dictionary<String,JSON>) -> Visual {
        let colorDark = UIColor(hex:  json["color_dark"]!.string! + "ff")!
        let colorLight = UIColor(hex: json["color_light"]!.string! + "ff")!
        let colorAccent = UIColor(hex: json["color_accent"]!.string! + "ff")!
        var visual = Visual(colorDark: colorDark, colorLight: colorLight, colorAccent: colorAccent)
    
        return visual
    }
    
    public init() {
        visual = Visual()
    }
    
    
}
