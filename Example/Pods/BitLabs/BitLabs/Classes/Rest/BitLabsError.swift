//
//  BitLabsError.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//


import Foundation

public enum BitLabsError: Error {
    
    case InvalidStatusCode(String)
    case MissingStatusCodeInResponse
    case MissingResponseData
    case InconsitentJSON(String)
    case InconsitentReponse(String)
}
