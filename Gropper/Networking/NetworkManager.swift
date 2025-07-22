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
    
    func execute<T: Codable>(endpoint: Endpoint, auth: Bool, type: T.Type) async throws -> T?{
        var request = try endpoint.urlRequest()

        if (auth) {
            guard let accessToken = getToken(forKey: "accessToken") else {
                throw NetworkError.noAccessToken
            }
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else{
            throw NetworkError.noResponse
        }
        
        switch response.statusCode{
            case 200:
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }//decode data from response
            
            case 401:
                guard let refreshToken = getToken(forKey: "refreshToken") else {
                    throw NetworkError.unauthorized
                }
                let request = Authentication.verifyRefreshToken(token: refreshToken)
                do {
                    guard let tokens = try await execute(endpoint: request, auth: false, type: WebTokens.self) else {
                        throw NetworkError.unauthorized
                    }
                    guard let accessToken = tokens.accessToken else {
                        throw NetworkError.unauthorized
                    }
                    try updateToken(token: accessToken, forKey: "accessToken")
                    return try await self.execute(endpoint: endpoint, auth: true, type: type)
                }//get new access token and store it in Keychain
            
            case 403:
                throw NetworkError.unauthorized
            
            default:
            throw NetworkError.invalidResponse
        }
    }
}


