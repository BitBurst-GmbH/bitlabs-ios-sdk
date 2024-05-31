//
//  HookMessageUtils.swift
//  BitLabs
//
//  Created by Omar Raad on 30.05.24.
//

import Foundation

extension String {
    func asHookMessage() -> HookMessage? {
        do {
            return try JSONDecoder().decode(HookMessage.self, from: data(using: .utf8)!)
        } catch {
            print("Decoding failed: \(error)")
            return nil
        }
    }
}

enum HookName: String, Codable {
    case sdkClose = "offerwall-core:sdk.close"
}

struct HookMessage: Codable {
    let type: String
    let name: HookName
    let args: [Argument]
}

enum Argument: Codable {
    case intValue(Int)
    case stringValue(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
        } else {
            throw DecodingError.typeMismatch(Argument.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type not matched"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intValue(let intValue):
            try container.encode(intValue)
        case .stringValue(let stringValue):
            try container.encode(stringValue)
        }
    }
}
