//
//  DashboardViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation
import Contacts

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
    }
    
    func retrieveTrips(){
        Task{
            do{
                let request = TripData.getTrips(user: userNumber)
                let tripsResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: AllTrips.self)
                if let trips = tripsResponse {
                    self.hostedTrips = trips.hostedTripData
                    self.requestedTrips = trips.requestedTripData
                }
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
    
    func retrieveContact(user: RequestorInfo) async -> RequestorInfo{
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
    }
    
    func requestContactAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }
}
