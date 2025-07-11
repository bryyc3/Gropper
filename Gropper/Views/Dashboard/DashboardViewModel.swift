//
//  DashboardViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var trips = AllTrips()
    @Published var loggedIn = true
    
    func retrieveTrips(){
        Task{
            do{
                let request = try TripData.getTrips(token: getToken(forKey: "accessToken"))
                trips = try await NetworkManager.shared.execute(endpoint: request, type: AllTrips.self) ?? AllTrips()
            } catch NetworkError.invalidURL {
                print ("invalid URL")
            } catch NetworkError.invalidResponse {
                print ("invalid response")
            } catch {
                print ("unexpected error")
            }
        }
    }
    
    func removeTokens(){
        Task{
            do{
                try deleteToken(forKey: "accessToken")
                try deleteToken(forKey: "refreshToken")
            } catch KeychainError.unknown{
                print("error")
            }
        }
    }
}
