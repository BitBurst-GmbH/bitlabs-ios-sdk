//
//  SentryEventItem.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEventItem: SentryEnvelopeItem {
    let event: SentryEvent
    
    func toData() throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let eventData = try jsonEncoder.encode(event)
        
        let eventJson = String(data: eventData, encoding: .utf8) ?? ""
        let itemHeadersJson = """
        {"type": "event", "length": \(eventJson.utf8.count)}
        """
        
        let item = """
        \(itemHeadersJson)
        \(eventJson)
        """
        
        return Data(item.utf8)
    }
}
