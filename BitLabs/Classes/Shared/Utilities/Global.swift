//
//  Global.swift
//  BitLabs
//
//  Created by Omar Raad on 16.06.22.
//

import Foundation

let bundle = Bundle(for: WebViewController.self)

func randomSurveys() -> [Survey] {
    var surveys = [Survey]()
    
    for i in 1...3 {
        surveys.append(Survey(id: String(i), type: "survey", clickUrl: "", cpi: "0.5", value: "500", loi: Double.random(in: 1.0...30.0), country: "US", language: "en", rating: Int.random(in: 1...5), category: Category(name: "Survey-\(i)", iconUrl: "", iconName: "", nameInternal: ""), tags: ["recontact", "pii"]))
    }
    
    return surveys
}

class Exception: Error, CustomStringConvertible {
    let message: String
    
    public var description: String { return message }
    
    init(_ message: String) {
        self.message = message
    }
}

func changeGradient(of view: UIView, withColors colors: [UIColor]) {
    let gradient = CAGradientLayer()
    gradient.colors = colors.map { $0.cgColor }
    gradient.cornerRadius = view.layer.cornerRadius
    gradient.frame = view.bounds
    gradient.startPoint = CGPoint(x: 0, y: 1)
    gradient.endPoint = CGPoint(x: 1, y: 0)
    view.layer.insertSublayer(gradient, at: 0)
}

func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: .ascii)
    
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    
    filter.setValue(data, forKey: "inputMessage")
    
    let transform = CGAffineTransform(scaleX: 3, y: 3)
    guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
    
    return UIImage(ciImage: output);
}
