//
//  GetTrips.swift
//  Gropper
//
//  Created by Bryce King on 5/7/25.
//

import Foundation


func getTrips() async throws -> [TripInfo]{
    let endpoint = "http://localhost:8080/trips"
    guard let url = URL(string: endpoint) else{
        throw TripDataError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw TripDataError.invalidResponse
    }
    
    do{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let tripData: [TripInfo] =  try decoder.decode([TripInfo].self, from: data)
        return tripData
    } catch {
        throw TripDataError.decodingError
    }
}//get all trips user is involved in


enum TripDataError: Error{
    case invalidURL
    case invalidResponse
    case decodingError
}
