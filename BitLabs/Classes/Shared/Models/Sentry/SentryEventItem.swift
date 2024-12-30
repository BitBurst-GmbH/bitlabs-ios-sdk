//
//  SentryEventItem.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEventItem: SentryEnvelopeItem, Encodable {
    let event: SentryEvent
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let eventData = try jsonEncoder.encode(event)
        
        let eventJson = String(data: eventData, encoding: .utf8) ?? ""
        let itemHeadersJson = """
        {"type": "event", "length": \(eventJson.count)}
        """
        
        let fullJson = """
        \(itemHeadersJson)
        \(eventJson)
        """
        
        try container.encode(fullJson)
    }
}
