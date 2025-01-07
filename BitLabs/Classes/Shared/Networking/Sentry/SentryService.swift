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
    
    func sendEnvelope(withException exception: Exception) {
        print("sending Envelope")
        let envelope = createEnvelope(fromException: exception)
        
        do {
            let encodedEnvelope = try envelope.toData()
            print(String(data: encodedEnvelope, encoding: .utf8) ?? "")
            
            let url = try createURL(body: encodedEnvelope)
            
            session.request(url).responseString { response in
                print(response.result)
            }
        } catch(let e) {
            print("Error Sending envelope: " + e.localizedDescription)
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
    
    func createEnvelope(fromException error: Error) -> SentryEnvelope {
        let errorType = String(describing: type(of: error))
        let errorMessage = error.localizedDescription.isEmpty ? "Unlabelled exception" : error.localizedDescription
        
        let eventID = UUID().uuidString.lowercased()
        let now = ISO8601DateFormatter().string(from: Date())
        
        let exception = SentryException(
            type: errorType,
            value: errorMessage,
            module: errorType,
            stacktrace: SentryStackTrace(frames: Thread.callStackSymbols.map { symbol in
                return SentryStackFrame(function: symbol, lineno: 0, inApp: true)
            }),
            mechanism: SentryExceptionMechanism(handled: true)
        )
        
        let event = SentryEvent(
            eventId: eventID,
            timestamp: now,
            logentry: SentryMessage(formatted: errorMessage),
            level: "error",
            tags: ["token": "testToken"],
            user: SentryUser(id: eventID),
            sdk: SentrySDK(version: "0.1.0"),
            exception: nil
        )
        
        let eventItem = SentryEventItem(event: event)
        
        let envelope = SentryEnvelope(headers: SentryEnvelopeHeaders(eventId: eventID, sentAt: now, dsn: SentryManager.shared.dsn.asString()), items: [eventItem])
        
        return envelope
    }
}
