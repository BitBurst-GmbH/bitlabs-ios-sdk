//
//  BrowserDelegate.swift
//  BitLabSDK
//
//  Created by Frank Marx on 20.11.20.
//

import UIKit
import SafariServices

public class BrowserDelegate {
    
    public enum Constants {
        public static let baseURL = "https://web.bitlabs.ai"
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"

    }
    
    public static var instance = BrowserDelegate()
    
    var safariVC: SFSafariViewController?
    
    private init() {
    }
    
    /*
     var components = URLComponents(string: url.absoluteString)!
     let query = URLQueryItem(name: "platform", value: p.rawValue)
     
     components.queryItems = [query]
     let checkSurveyURL = components.url!
     let headers = assembleHeaders(appToken: token, userId: userId)
     */
    public func show(parent: UIView, withUserId userId : String, token: String ) -> SFSafariViewController?  {
        let url = buildURL(userId: userId, apiToken: token)
        
        guard let u = url else {
            debugPrint("| Invalid url")
            return nil
        }
        
        safariVC = SFSafariViewController(url: u)
                
        var i = 2
        
        return safariVC
    }
     
    
    func buildURL(userId: String, apiToken: String) -> URL? {
        var components = URLComponents(string: Constants.baseURL)!
        let queryUUID = URLQueryItem(name: "uid", value: userId)
        let queryAPIToken = URLQueryItem(name: "token", value: apiToken)
        components.queryItems = [queryUUID, queryAPIToken]
        
        do {
            let url = try components.asURL()
            return url
        } catch( let error ) {
            debugPrint("| Error creating URL_ \(error)")
        }
        
        return nil
    }
    
    
}
