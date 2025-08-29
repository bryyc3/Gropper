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

enum TripType {
    case host
    case request
    
    var createTripButtonTitle: String {
        switch self {
            case .host:
                return "Create Trip"
            case .request:
                return "Request Trip"
        }
    }
    
    var createTripImage: String {
        switch self {
            case .host:
                return "host_trip_img"
            case .request:
                return "request_trip_img"
        }
    }
    
    var createTripTitle: String {
        switch self {
        case .host:
            return "Heading out and willing to pick up items"
        case .request:
            return "Request someone to pick up items for you"
        }
    }
    
    var createTripSubtitle: String {
        switch self {
        case .host:
            return "Let others know where youre going and that you can pick up items they need"
        case .request:
            return "Request for someone to pick up items you need from a specified location."
        }
    }
    
    var tripPreviewTitle: String {
        switch self {
            case .host:
                return "Trips Youre Hosting"
            case .request:
                return "Trips Youre Apart Of"
        }
    }
    
    var colorScheme: [Color] {
        switch self {
            case .host:
            return [Color(#colorLiteral(red: 0.8416427374, green: 0.8715619445, blue: 0.9481450915, alpha: 1)),Color(#colorLiteral(red: 0.5456431508, green: 0.6622825265, blue: 0.8428704143, alpha: 0.8952555878))]
        case .request:
            return [Color(#colorLiteral(red: 0.8366934657, green: 0.7335241437, blue: 0.8978629708, alpha: 1)),Color(#colorLiteral(red: 0.6828602552, green: 0.4983463287, blue: 0.9405499697, alpha: 1))]
        }
    }
}
