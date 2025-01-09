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
            let regex = #"(\{"type":".*?","name":".*?","args":\[.*?\]\})"#
            
            guard let _ = range(of: regex, options: .regularExpression) else {
                return nil
            }
            
            return try JSONDecoder().decode(HookMessage.self, from: data(using: .utf8)!)
        } catch DecodingError.dataCorrupted(let context) where context.codingPath.contains(where: { $0.stringValue == "name" }) {
            return nil
        } catch {
            let errString = "[BitLabs] Decoding failed: \(error)"
            print(errString)
            SentryManager.shared.captureException(error: Exception(errString), stacktrace: Thread.callStackSymbols)
            return nil
        }
    }
}

enum HookName: String, Codable {
    case unwanted
    case initOfferwall = "offerwall-core:init"
    case sdkClose = "offerwall-core:sdk.close"
    case surveyStart = "offerwall-surveys:survey.start"
    case surveyComplete = "offerwall-surveys:survey.complete"
    case surveyScreentout = "offerwall-surveys:survey.screenout"
    case surveyStartBonus = "offerwall-surveys:survey.start-bonus"
}

struct HookMessage: Codable {
    let type: String
    let name: HookName
    let args: [Argument]
}

struct RewardArgument: Codable {
    let reward: Float
}

struct SurveyStartArgument: Codable {
    let clickId: String
    let link: String
}

// Helper Codable Struct
struct CodableValue: Codable {}

enum Argument: Codable {
    case reward(RewardArgument)
    case surveyStart(SurveyStartArgument)
    case unknownData([String: CodableValue])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rewardArgument = try? container.decode(RewardArgument.self) {
            self = .reward(rewardArgument)
        } else if let surveyStartArgument = try? container.decode(SurveyStartArgument.self) {
            self = .surveyStart(surveyStartArgument)
        } else if let data = try? container.decode([String: CodableValue].self) {
            self = .unknownData(data)
        } else {
            throw DecodingError.typeMismatch(Argument.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type not matched"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .reward(let rewardArgument):
            try container.encode(rewardArgument)
        case .surveyStart(let surveyStartArgument):
            try container.encode(surveyStartArgument)
        case .unknownData(let data):
            try container.encode(data)
        }
    }
}
