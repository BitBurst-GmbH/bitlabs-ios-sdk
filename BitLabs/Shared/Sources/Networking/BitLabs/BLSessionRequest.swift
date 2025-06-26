//
//  BLSessionRequest.swift
//  Pods
//
//  Created by Omar Raad on 23.06.25.
//

import Foundation

class BLSessionRequest {
    private let session: URLSession
    private let request: URLRequest
    
    init(session: URLSession, request: URLRequest) {
        self.session = session
        self.request = request
    }
    
    func responseDecodable<T: Decodable>(of type: T.Type, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                completion(.success(try decoder.decode(T.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
