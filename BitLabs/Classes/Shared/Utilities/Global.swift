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
        surveys.append(Survey(networkId: Int.random(in: 1...1000), id: i, cpi: "0.5", value: "0.5", loi: Double.random(in: 1.0...30.0), remaining: 3, details: Details(category: Category(name: "General", iconUrl: "")), rating: Int.random(in: 1...5), link: "", missingQuestions: 0))
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
