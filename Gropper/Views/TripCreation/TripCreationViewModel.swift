//
//  TripCreationViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation
import ContactsUI
import SwiftUI
@MainActor
class TripCreationViewModel: NSObject, ObservableObject, CNContactPickerDelegate {
    let userNumber: String
    @Published var tripData = TripInfo(host: ContactInfo(phoneNumber: ""))
    @Published var selectedContacts: [ContactInfo] = []
    @Published var items: [ItemInfo] = [ItemInfo()]
    @Published var hostContact = ContactInfo(phoneNumber: "")
    @Published var successfulTripCreation = false
     
    override init(){
        guard let phoneNumber = getItem(forKey: "userPhoneNumber") else {
            AuthManager.shared.logout()
            userNumber = ""
            return
        }
        userNumber = phoneNumber
    }
    
    func createHostedTrip() {
        tripData.status = 1
        tripData.host.phoneNumber = userNumber
        tripData.tripId = UUID().uuidString
        tripCreation()
    }//create trip
    
    func requestTrip() {
        tripData.host.phoneNumber = hostContact.phoneNumber
        tripData.requestors.append(ContactInfo(phoneNumber: userNumber, itemsRequested: items))
        tripData.tripId = UUID().uuidString
        tripCreation()
    }//request trip
    
    
    func tripCreation() {
        Task{
            do{
                let request = TripData.createTrip(tripInformation: tripData, contacts: selectedContacts)
                guard let tripCreated = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                    throw NetworkError.invalidResponse
                }
                if (tripCreated) {
                    successfulTripCreation = tripCreated
                } else {
                    print ("couldnt create trip")
                }
            } catch NetworkError.invalidURL {
                print ("create trip invalid URL")
            } catch NetworkError.invalidResponse {
                print ("create trip invalid response")
            } catch NetworkError.unauthorized{
                AuthManager.shared.logout()
            } catch {
                print ("create trip unexpected error")
            }
         }
    }
}
