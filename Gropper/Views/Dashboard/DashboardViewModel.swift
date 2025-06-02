//
//  DashboardViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation

class DashboardViewModel: ObservableObject {
    @Published var trips = AllTrips()
    func retrieveTrips(){
        Task{
            do{
                trips = try await getTrips()
                print(trips)
            } catch TripDataError.invalidURL {
               print ("invalid URL")
           }  catch TripDataError.invalidResponse {
               print ("invalid response")
           } catch {
               print ("unexpected error")
           }
        }
    }
}
