//
//  Global.swift
//  BitLabs
//
//  Created by Omar Raad on 16.06.22.
//

import Foundation
import UIKit

#if SWIFT_PACKAGE
let bundle = Bundle.module
#else
let bundle = {
    let frameworkBundle = Bundle(for: WebViewController.self)

    // Try resource bundle first
    if let resourceBundleURL = frameworkBundle.url(forResource: "BitLabsResources", withExtension: "bundle"),
       let resourceBundle = Bundle(url: resourceBundleURL) {
        return resourceBundle
    }

    // If failed, check if the XIB exists directly in framework (needed in Unity where CocoaPods doesn't create bundle)
    if frameworkBundle.path(forResource: "WebViewController", ofType: "xib") != nil {
        return frameworkBundle
    }

    // Last resort: return framework bundle and let it fail with proper error
    return frameworkBundle
}()
#endif

class Exception: Error, CustomStringConvertible {
    let message: String
    
    public var description: String { return message }
    
    init(_ message: String) {
        self.message = message
    }
}

func changeGradient(of view: UIView, withColors colors: [UIColor]) {
    view.layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }

    let gradient = CAGradientLayer()
    gradient.colors = colors.map { $0.cgColor }
    gradient.cornerRadius = view.layer.cornerRadius
    gradient.startPoint = CGPoint(x: 0, y: 1)
    gradient.endPoint = CGPoint(x: 1, y: 0)
    gradient.frame = view.bounds
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

func createUserAgent() -> String {
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad ? "Tablet" : "Phone"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let systemVersion = UIDevice.current.systemVersion
    
    func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String.init(validatingUTF8: $0)
            }
        }
        return modelCode ?? UIDevice.current.model
    }
    
    return "BitLabs/\(appVersion) (iOS \(systemVersion); \(modelIdentifier()); \(deviceType))"
}
