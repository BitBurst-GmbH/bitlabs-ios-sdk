//
//  RestService.swift
//  BitLabSDK
//
//  Created by Frank Marx on 09.11.20.
//

import Foundation

public class RestService {
    
    public enum Constants {
        public static let baseURL = URL(string: "https://api.bitlabs.ai/v1/client")
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"
    }
    
    
    public static let instance: RestService = {
        let this = RestService()
        return this
    }()
    
    
    
    private init() {
        
    }
    
    
}


