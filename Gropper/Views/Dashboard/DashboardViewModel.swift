//
//  DashboardViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation
import Contacts
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    let userNumber: String
    @Published var hostedTrips: [TripInfo]?
    @Published var requestedTrips: [TripInfo]?
    
     init(){
        guard let phoneNumber = getItem(forKey: "userPhoneNumber") else {
            AuthManager.shared.logout()
            userNumber = ""
            return
        }
        userNumber = phoneNumber
        Task{
             await retrieveTrips()
        }
    }
    
    func retrieveTrips() async {
        do{
            let request = TripData.getTrips(user: userNumber)
            let tripsResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: AllTrips.self)
            
            if let trips = tripsResponse {
                if var tripsHosted = trips.hostedTripData {
                    for (tripIndex, _) in tripsHosted.enumerated() {
                        for (requestorIndex, requestor) in tripsHosted[tripIndex].requestors.enumerated() {
                            tripsHosted[tripIndex].requestors[requestorIndex] = await retrieveContact(user: requestor)
                        }
                    }
                    self.hostedTrips = tripsHosted
                }
                
                if var tripsRequested = trips.requestedTripData {
                    for (tripIndex, trip) in tripsRequested.enumerated() {
                        tripsRequested[tripIndex].host = await retrieveContact(user: trip.host)
                    }
                    self.requestedTrips = tripsRequested
                }
            } else {
                self.hostedTrips = nil
                self.requestedTrips = nil
            }// iterate through each type of trip and store contact info hosts and requestors
            
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
    
    func retrieveContact(user: ContactInfo) async -> ContactInfo{
        let access = CNContactStore.authorizationStatus(for: .contacts)
        
        switch access {
            case .authorized:
                return getContact(for: user)

            case .notDetermined:
                let granted = await requestContactAccess()
                return granted ? getContact(for: user) : user
                
            case .denied, .restricted, .limited:
                return user
                
            @unknown default:
                return user
        }
    }//determine access to contacts and carry out appropriate function based on user selection
    
    func requestContactAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }//request for access to contacts
}
