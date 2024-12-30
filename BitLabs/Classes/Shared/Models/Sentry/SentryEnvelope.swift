//
//  SentryEnvelope.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEnvelope: Encodable {
    let headers: SentryEnvelopeHeaders
    let items: [SentryEnvelopeItem]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        let jsonEncoder =  JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        let headersJson = String(data: try! jsonEncoder.encode(headers), encoding: .utf8) ?? ""
        let itemsJson = items.map {
            try! String(data: jsonEncoder.encode($0), encoding: .utf8) ?? ""
        }.joined(separator: "\n")
        
        let envelopeJson = """
        \(headersJson)
        \(itemsJson)
        """
        
        try! container.encode(envelopeJson)
    }
}

protocol SentryEnvelopeItem: Encodable {}
