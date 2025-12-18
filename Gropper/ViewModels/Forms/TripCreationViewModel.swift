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
            tripCreation()
        } catch NumberParseError.parseErr{
            print("Number Parse Error")
        } catch {
            print("Uknown request error")
        }
       
    }//create trip
    
    func requestTrip() {
        do {
            guard let hostNumber = try? NumberParse(number: hostContact.phoneNumber) else {
                throw NumberParseError.parseErr
            }//parse host number
            tripData.host.phoneNumber = hostNumber
            tripData.requestors.append(ContactInfo(phoneNumber: userNumber, itemsRequested: items))
            tripData.tripId = UUID().uuidString
            tripCreation()
        } catch NumberParseError.parseErr {
            print("Number Parse Error")
        } catch {
            print("Uknown request error")
        }
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
