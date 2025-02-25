//
//  Global.swift
//  BitLabs
//
//  Created by Omar Raad on 16.06.22.
//

import Foundation

let bundle = Bundle(for: WebViewController.self)

class Exception: Error, CustomStringConvertible {
    let message: String
    
    public var description: String { return message }
    
    init(_ message: String) {
        self.message = message
    }
}

func changeGradient(of view: UIView, withColors colors: [UIColor]) {
    view.layoutIfNeeded()
    print("View bounds", view.bounds)
    view.layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }

    let gradient = CAGradientLayer()
    gradient.colors = colors.map { $0.cgColor }
    gradient.cornerRadius = view.layer.cornerRadius
    gradient.startPoint = CGPoint(x: 0, y: 1)
    gradient.endPoint = CGPoint(x: 1, y: 0)
    print("gradient frame before view", gradient.frame)
    gradient.frame = view.bounds
    print("gradient frame after view", gradient.frame)
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

/// Generates the URL the BitLabs Offerwall
/// - Tag: generateURL
func generateURL(uid: String, token: String, sdk: String, adId: String, tags: [String: Any]) -> URL? {
    guard var urlComponents = URLComponents(string: "https://web.bitlabs.ai") else { return nil }
    
    var queryItems = [
        URLQueryItem(name: "uid", value: uid),
        URLQueryItem(name: "token", value: token),
        URLQueryItem(name: "os", value: "IOS"),
        URLQueryItem(name: "sdk", value: sdk)]
    
    if !adId.isEmpty {
        queryItems.append(URLQueryItem(name: "maid", value: adId))
    }
    
    tags.forEach { tag in
        queryItems.append(URLQueryItem(name: tag.key, value: String(describing: tag.value)))
    }
    
    urlComponents.queryItems = queryItems
    
    return urlComponents.url
}
