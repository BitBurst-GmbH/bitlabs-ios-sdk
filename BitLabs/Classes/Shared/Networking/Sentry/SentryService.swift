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
    
    private let token: String
    private let uid: String
        
    init(_ token: String, _ uid: String) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.token = token
        self.uid = uid
    }
    
    func sendEnvelope(withException exception: Any, in stacktrace: [String], isHandled: Bool, _ completionHandler: @escaping () -> ()) {
        let envelope = createEnvelope(fromException: exception, andStackSymbols: stacktrace, isHandled: isHandled)
        
        do {
            let encodedEnvelope = try envelope.toData()
            
            let url = try createURL(body: encodedEnvelope)
            
            AF.request(url).responseDecodable(of: SendEnvelopeResponse.self) { response in
                switch(response.result) {
                case .success(let sendEnvelopeResponse):
                    print("[BitLabs] Sent Envelope(#\(sendEnvelopeResponse.id)) to Sentry.")
                case .failure(let error):
                    print("[BitLabs] Error Sending envelope: " + error.localizedDescription)
                }
                
                completionHandler()
            }
        } catch(let e) {
            print("[BitLabs] Error Sending envelope: " + e.localizedDescription)
        }
    }
    
    func createURL(body: Data) throws -> URLRequest {
        let headers = HTTPHeaders([
            "X-Sentry-Auth": "Sentry sentry_version=7, sentry_key=\(SentryManager.shared.publicKey), sentry_client=bitlabs-sdk/0.1.0",
            "User-Agent": "bitlabs-sdk/0.1.0",
            "Content-Type": "application/x-sentry-envelope"
        ])
        
        var request = try URLRequest(url: SentryManager.shared.url + "api/\(SentryManager.shared.projectID)/envelope/", method: .post, headers: headers)
        request.httpBody = body
        
        return request
    }
    
    func createEnvelope(fromException exception: Any, andStackSymbols stackSymbols: [String], isHandled: Bool) -> SentryEnvelope {
        let errorType = String(describing: type(of: exception))
        let errorMessage = switch exception {
        case let bitlabsException as Exception: bitlabsException.message
        case let nsException as NSException: nsException.reason ?? "Unlabeled Error"
        case let error as Error: error.localizedDescription.isEmpty ? "Unlabeled Error": error.localizedDescription
        default: "Unlabeled Error"
        }
        
        let eventID = UUID().uuidString.lowercased()
        let now = ISO8601DateFormatter().string(from: Date())
        
        let exception = SentryException(
            type: errorType,
            value: errorMessage,
            module: errorType,
            stacktrace: SentryStackTrace(frames: stackSymbols.map { symbol in
                return SentryStackFrame(function: symbol, lineno: 0, inApp: symbol.contains(" BitLabs "))
            }),
            mechanism: SentryExceptionMechanism(handled: isHandled)
        )
        
        let event = SentryEvent(
            eventId: eventID,
            timestamp: now,
            logentry: SentryMessage(formatted: errorMessage),
            level: isHandled ? "error" : "fatal",
            tags: ["token": self.token],
            user: SentryUser(id: self.uid),
            sdk: SentrySDK(version: "0.1.0"),
            exception: [exception]
        )
        
        let eventItem = SentryEventItem(event: event)
        
        let envelope = SentryEnvelope(headers: SentryEnvelopeHeaders(eventId: eventID, sentAt: now, dsn: SentryManager.shared.dsn.asString()), items: [eventItem])
        
        return envelope
    }
}
