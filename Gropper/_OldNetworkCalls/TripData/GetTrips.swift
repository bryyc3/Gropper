////
////  GetTrips.swift
////  Gropper
////
////  Created by Bryce King on 5/7/25.
////
//
//import Foundation
//
//
//func getTrips() async throws -> AllTrips{
//    let accessToken = getToken(forKey: "accessToken")
//    let endpoint = "http://localhost:8080/trips"
//    
//    guard let url = URL(string: endpoint) else{
//        throw TripDataError.invalidURL
//    }
//    
//    var request = URLRequest(url: url)
//    if let token = accessToken{
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//    }
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    
//    guard let response = response as? HTTPURLResponse else{
//        throw TripDataError.noResponse
//    }
//    
//    if response.statusCode != 200 {
//        if response.statusCode == 401 {
//            let refreshValidated = await verifyRefreshToken()
//            if refreshValidated {
//                return try await getTrips()
//                //refresh token is valid and a new access token is stored
//            }
//            else{
//                throw TripDataError.invalidResponse
//                //the refresh token is invalid so user needs to login again
//            }
//        }
//        else{
//            throw TripDataError.invalidResponse
//        }
//    }
//    
//    do{
//        let decoder = JSONDecoder()
//        let tripData: AllTrips =  try decoder.decode(AllTrips.self, from: data)
//        return tripData
//    } catch {
//        throw TripDataError.decodingError
//    }
//}//get all trips user is involved in
//
//
//enum TripDataError: Error{
//    case invalidURL
//    case noResponse
//    case invalidResponse
//    case decodingError
//}
