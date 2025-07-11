//
//  TripCreationViewModel.swift
//  Gropper
//
//  Created by Bryce King on 5/28/25.
//

import Foundation
import ContactsUI
import SwiftUI

class TripCreationViewModel: NSObject, ObservableObject, CNContactPickerDelegate{
    @Published var tripData = TripInfo()
    @Published var selectedContacts: [ContactInfo] = []
    @Published var items: [ItemInfo] = []
    @Published var hostContact = ContactInfo()
    @Published var successfulTripCreation = false
    
    
    func createHostedTrip(){
        tripData.status = 1
        tripData.host = "1111111111"
        tripData.tripId = UUID().uuidString
        tripCreation()
    }//create trip
    
    func requestTrip(){
        tripData.host = hostContact.phoneNumber
        tripData.itemsRequested = items
        tripData.tripId = UUID().uuidString
        tripCreation()
    }//request trip
    
    func tripCreation(){
        Task{
            do{
                let request = try TripData.createTrip(tripInformation: tripData,
                                                      contacts: selectedContacts,
                                                      token: getToken(forKey: "accessToken"))
                successfulTripCreation = try await NetworkManager.shared.execute(endpoint: request, type: Bool.self) ?? false
            } catch NetworkError.invalidURL {
                print ("invalid URL")
            }  catch NetworkError.invalidResponse {
                print ("invalid response")
            } catch {
                print ("unexpected error")
            }
         }
    }
}
