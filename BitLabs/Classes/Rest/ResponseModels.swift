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

public struct Currency {
    public var format: String
    public var exchangeFactor: String
    public var iconURL: String
    
}

public struct Visual {
    public var colorDark: UIColor
    public var colorLight: UIColor
    public var colorAccent: UIColor
    public var mode: String
    
    init() {
        colorDark = UIColor(hex: "#000000ff")!
        colorLight = UIColor(hex: "#ffee88ff")!
        colorAccent = UIColor(hex: "#aa4488ff")!
        mode = "OFFEREWALL"
    }
    
    init( colorDark: UIColor, colorLight: UIColor, colorAccent: UIColor, mode: String) {
        self.colorDark = colorDark
        self.colorLight = colorLight
        self.colorAccent = colorAccent
        self.mode = mode
    }
    
}

struct LeaveReasonData {
    var reason: String
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
        var colorDark = visual.colorDark
        var colorLight = visual.colorLight
        var colorAccent = visual.colorAccent
        
        if let cDark = json["color_dark"] {
            colorDark = UIColor(hex: cDark.string! + "ff")!
        }
        if let cLight = json["color_light"] {
            colorLight = UIColor(hex: cLight.string! + "ff")!
        }
     
        if let cAccent = json["color_accent"] {
            colorAccent = UIColor(hex: cAccent.string! + "ff")!
        }

        let mode = String( json["mode"]!.string!)
        let visual = Visual(colorDark: colorDark, colorLight: colorLight,
                            colorAccent: colorAccent,mode: mode)
    
        return visual
    }
    
    public init() {
        visual = Visual()
    }
    
    
}
