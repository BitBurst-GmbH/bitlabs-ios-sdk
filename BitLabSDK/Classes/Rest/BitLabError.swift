//
//  BitLabError.swift
//  BitLabSDK
//
//  Created by Frank Marx on 10.11.20.
//

import Foundation

public enum BitlabError: Error {
    
    case InvalidStatusCode(String)
    case MissingStatusCodeInResponse
    case InconsitentReponse(String)
}
