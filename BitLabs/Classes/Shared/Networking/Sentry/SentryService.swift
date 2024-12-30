//
//  SentryService.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation
import Alamofire

class SentryService {
    private let decoder = JSONDecoder()
    
    private let session: Session
    
    init(_ session: Session) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = session
    }
    
    func sendEnvelope(withException exception: Exception, completion: @escaping () -> ()) {
        
    }
}
