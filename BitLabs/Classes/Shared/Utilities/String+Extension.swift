//
//  String+Extension.swift
//  BitLabs
//
//  Created by Omar Raad on 16.06.22.
//

import Foundation

extension String {
    var localized: String {
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    var toUIColor: UIColor {
        let string = self
            .trimmingCharacters(in:.whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        
        var rgbValue:UInt64 = 0
        Scanner(string: string).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
