//
//  CreateTrip.swift
//  Gropper
//
//  Created by Bryce King on 5/6/25.
//

import Foundation
import ContactsUI


func createTrip(tripInformation: TripInfo, contacts: [ContactInfo]?) async throws -> Bool{
    let tripData = try JSONEncoder().encode(tripInformation)
    let contactData = try JSONEncoder().encode(contacts)
    
    guard let tripJsonString = String(data: tripData, encoding: .utf8),
          let contactJsonString = String(data: contactData, encoding: .utf8) else{
        throw TripCreationError.encodingError
    }//encode data to be sent as JSON
    
    let endpoint = "http://localhost:8080/create-trip"
    guard let url = URL(string: endpoint) else{
        throw TripCreationError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["tripInfo": tripJsonString,
                "contacts": contactJsonString]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let (_,response) = try await URLSession.shared.data(for: request)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw TripCreationError.invalidResponse
    }
    return true
}//store trip information in DB


enum TripCreationError: Error{
    case invalidURL
    case invalidResponse
    case decodingError
    case encodingError
}
