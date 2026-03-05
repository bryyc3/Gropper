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
            Task {
                try await AuthManager.shared.logout()
            }
            userNumber = ""
            return
        }
        userNumber = phoneNumber
    }
    
    func createHostedTrip() async throws -> ApiResponse {
        do {
            for (index, requestor) in selectedContacts.enumerated() {
                guard let requestorNumber = try? NumberParse(number: requestor.phoneNumber) else {
                    throw NumberParseError.parseErr
                }
                selectedContacts[index].phoneNumber = requestorNumber
            }//parse requestor numbers
            tripData.status = 1
            tripData.host.phoneNumber = userNumber
            tripData.tripId = UUID().uuidString
        } catch NumberParseError.parseErr{
            print("Number Parse Error")
        } catch {
            print("Uknown request error")
        }
        return try await tripCreation()
       
    }//create trip
    
    func requestTrip() async throws -> ApiResponse {
        do {
            guard let hostNumber = try? NumberParse(number: hostContact.phoneNumber) else {
                throw NumberParseError.parseErr
            }//parse host number
            tripData.host.phoneNumber = hostNumber
            tripData.requestors.append(ContactInfo(phoneNumber: userNumber, itemsRequested: items))
            tripData.tripId = UUID().uuidString
        } catch NumberParseError.parseErr {
            print("Number Parse Error")
        } catch {
            print("Uknown request error")
        }
        return try await tripCreation()
    }//request trip
    
    
    func tripCreation() async throws -> ApiResponse {
        do{
            let request = TripData.createTrip(tripInformation: tripData, contacts: selectedContacts)
            guard let tripCreated = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if (tripCreated) {
                successfulTripCreation = tripCreated
            } else {
                return ApiResponse(status200: false, message: "Trip Creation Error - Couldnt Create Trip")
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Trip Creation Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Trip Creation Error - Invalid Response")
        } catch NetworkError.unauthorized{
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Unauthorized, log back in ")}
        } catch {
            return ApiResponse(status200: false, message: "Trip Creation Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
}
