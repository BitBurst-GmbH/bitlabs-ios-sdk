//
//  BitLabsRequestInterceptor.swift
//  BitLabs
//
//  Created by Omar Raad on 03/03/2022.
//

import Foundation
import Alamofire

class BitLabsRequestInterceptor: RequestInterceptor {
	
	private let token: String
	private let userId: String
    private var userAgent: String {
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
	
	init(_ token: String, _ userId: String) {
		self.token = token
		self.userId = userId
	}
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var request = urlRequest
		
		request.setValue(token, forHTTPHeaderField: "X-Api-Token")
		request.setValue(userId, forHTTPHeaderField: "X-User-Id")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
		
		completion(.success(request))
	}
}
