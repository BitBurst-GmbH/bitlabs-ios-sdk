//
//  File.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import Foundation
import SwiftyJSON



protocol ResponseStatusCheck {
    func checkStatusCode(json: JSON) -> Result<ResponseStatusCodes, Error>
}

public class BaseRestService: ResponseStatusCheck {
    
    func checkStatusCode(json: JSON) -> Result<ResponseStatusCodes, Error> {
      
        guard let statusCode = json["status"].string else {
            let error = BitLabsError.InvalidStatusCode("Status code is missing")
            let result: Result<ResponseStatusCodes,Error> = .failure(error)
            return result
        }
        
        if statusCode != "success" {
            let error = BitLabsError.InvalidStatusCode(statusCode)
            let result: Result<ResponseStatusCodes,Error> = .failure(error)
            return result
        }
        
        let result: Result<ResponseStatusCodes,Error> = .success(ResponseStatusCodes.successStatusCode)
        
        return result
    }
    
}