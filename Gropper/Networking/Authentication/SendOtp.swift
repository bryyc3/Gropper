//
//  SendOtp.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import Foundation

func sendOtp(mobileNumber: String) async throws -> Bool{
    let userPhoneNumber = try JSONEncoder().encode(mobileNumber)
    
    guard let userNumber = String(data: userPhoneNumber, encoding: .utf8) else {
        throw SendOtp.encodingError
    }
    
    let endpoint = "http://localhost:8080/simulate-otp"
    guard let url = URL(string: endpoint) else{
        throw SendOtp.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["phoneNumber": userNumber]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
 
    let (_, response) = try await URLSession.shared.data(for: request)
   
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw SendOtp.invalidResponse
    }
    return true

}

enum SendOtp: Error {
    case encodingError
    case invalidURL
    case invalidResponse
}
