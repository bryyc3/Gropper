//
//  DashboardViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var trips: AllTrips?
    
    func retrieveTrips(){
        Task{
            do{
                let request = TripData.getTrips()
                let tripsResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: AllTrips.self)
                trips = tripsResponse
            } catch NetworkError.invalidURL {
                print ("Dash invalid URL")
            } catch NetworkError.invalidResponse {
                print ("Dash invalid response")
            } catch NetworkError.decodingError {
                print ("Dashboard decoding error")
            } catch NetworkError.unauthorized {
                AuthManager.shared.logout()
            } catch {
                print ("Dash unexpected error")
            }
        }
    }
}
