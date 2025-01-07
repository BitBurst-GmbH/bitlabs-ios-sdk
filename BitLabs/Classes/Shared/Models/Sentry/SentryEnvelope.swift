//
//  SentryEnvelope.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEnvelope {
    let headers: SentryEnvelopeHeaders
    let items: [SentryEnvelopeItem]
    
    func toData() throws -> Data {
        let jsonEncoder =  JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        let headersJson = String(data: try! jsonEncoder.encode(headers), encoding: .utf8) ?? ""
        let itemsJson = items.map {
            try! String(data: $0.toData(), encoding: .utf8) ?? ""
        }.joined(separator: "\n")
        
        let envelope = """
        \(headersJson)
        \(itemsJson)
        """
        
        return Data(envelope.utf8)
    }
}

protocol SentryEnvelopeItem {
    func toData() throws -> Data
}
