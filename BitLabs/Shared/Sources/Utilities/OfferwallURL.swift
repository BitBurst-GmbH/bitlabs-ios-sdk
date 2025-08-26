//
//  OfferwallURL.swift
//  Pods
//
//  Created by Omar Raad on 26.08.25.
//

internal struct OfferwallURL {
    private let uid: String
    private let token: String
    private let sdk: String
    private let adId: String
    private let options: [String: Any]
    private let tags: [String: Any]
    
    init(uid: String, token: String, sdk: String, adId: String, options: [String : Any], tags: [String : Any]) {
        self.uid = uid
        self.token = token
        self.sdk = sdk
        self.adId = adId
        self.options = options
        self.tags = tags
    }
    
    var url: URL? {
        baseURLComponents().url
    }
    
    func offerUrl(forOfferId offerId: String) -> URL? {
        var components = baseURLComponents()
        components.path += "/offers"
        components.queryItems?.append(URLQueryItem(name: "offer-id", value: offerId))
        return components.url
    }
    
    private func baseURLComponents() -> URLComponents {
        var components = URLComponents(string: "https://web.bitlabs.ai")!
        
        var queryItems = [
            URLQueryItem(name: "uid", value: uid),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "os", value: "IOS"),
            URLQueryItem(name: "sdk", value: sdk)
        ]
        
        if !adId.isEmpty {
            queryItems.append(URLQueryItem(name: "maid", value: adId))
        }
        
        for (key, value) in options {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        
        for (key, value) in tags {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        
        components.queryItems = queryItems
        return components
    }
    
}
