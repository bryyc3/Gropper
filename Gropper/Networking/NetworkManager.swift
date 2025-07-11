//
//  NetworkManager.swift
//  Gropper
//
//  Created by Bryce King on 7/2/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    func execute<T: Codable>(endpoint: Endpoint, type: T.Type) async throws -> T?{
        let request = try endpoint.urlRequest()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        do{
            let decoder = JSONDecoder()
            let test = try decoder.decode(T.self, from: data)
            print(test)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}


