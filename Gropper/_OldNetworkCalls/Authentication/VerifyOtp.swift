//
//  VerifyOtp.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import Foundation

func verifyOtp(mobileNumber: String, otp: String) async throws -> WebTokens{
    let userPhoneNumber = try JSONEncoder().encode(mobileNumber)
    let userCode = try JSONEncoder().encode(otp)
    
    guard let userNumber = String(data: userPhoneNumber, encoding: .utf8),
          let password = String(data: userCode, encoding: .utf8) else {
        throw VerifyOtp.encodingError
    }
    
    let endpoint = "http://localhost:8080/simulate-otp-verification"
    guard let url = URL(string: endpoint) else{
        throw VerifyOtp.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["phoneNumber": userNumber,
                "userCode": password]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
 
    let (data, response) = try await URLSession.shared.data(for: request)

    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw VerifyOtp.invalidResponse
    }
    
    do{
        let decoder = JSONDecoder()
        let tokens: WebTokens =  try decoder.decode(WebTokens.self, from: data)
        return tokens
    } catch {
        throw NetworkError.decodingError
    }
}

enum VerifyOtp: Error {
    case encodingError
    case invalidURL
    case invalidResponse
    case decodingError
}

