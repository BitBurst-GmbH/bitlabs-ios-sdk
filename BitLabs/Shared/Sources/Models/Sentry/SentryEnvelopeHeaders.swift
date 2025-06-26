//
//  SentryEnvelopeHeaders.swift
//  BitLabs
//
//  Created by Omar Raad on 30.12.24.
//

import Foundation

struct SentryEnvelopeHeaders: Encodable {
    let eventId: String
    let sentAt: String
    let dsn: String
}
