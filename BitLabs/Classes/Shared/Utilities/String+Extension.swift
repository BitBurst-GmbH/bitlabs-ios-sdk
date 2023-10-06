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
    
    var toUIColor: UIColor? {
        let regex = try! NSRegularExpression(pattern: #"#([0-9a-fA-F]{6})"#)
        
        if regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).isEmpty {
            return nil
        }
        
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
    
    /// This method assumes that the string is a either a hex color or the linear gradient in the form 'linear-gradient(angle, color1, color2)'.
    /// It then extracts and returns color1 and color2. Otherwise, it will return the hex color as a UIColor twice in an array.
    var extractColors: [String] {
        let regex = try! NSRegularExpression(pattern: #"linear-gradient\((\d+)deg,\s*(.+)\)"#)
        
        guard let match = regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).first else {
            let regex = try! NSRegularExpression(pattern: #"#([0-9a-fA-F]{6})"#)
            
            if regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).isEmpty {
                return []
            }
            
            return [self, self] }
        
        var colors = String(self[Range(match.range(at: 2), in: self)!])
        
        colors = try! NSRegularExpression(pattern: #"([0-9]+)%"#).stringByReplacingMatches(in: colors, range: NSRange(colors.startIndex..., in: colors), withTemplate: "")
        
        return colors.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
