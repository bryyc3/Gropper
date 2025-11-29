//
//  AddItemsViewModel.swift
//  Gropper
//
//  Created by Bryce King on 9/18/25.
//

import Foundation

@MainActor
class AddItemsViewModel: NSObject, ObservableObject {
    let userNumber: String
    
    @Published var items: [ItemInfo] = [ItemInfo()]
    @Published var hostContact = ContactInfo(phoneNumber: "")
    @Published var successfullyAdded = false
    
    override init(){
        guard let phoneNumber = getItem(forKey: "userPhoneNumber") else {
            AuthManager.shared.logout()
            userNumber = ""
            return
        }
        userNumber = phoneNumber
    }
    
    func addItems(trip: String, tripHost: String) async {
        do{
            
            let request = TripData.updateItems(tripId: trip, host: tripHost, userPhone: userNumber, itemsRequested: items)
            
            guard let itemsAdded = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if(itemsAdded) {
                successfullyAdded = itemsAdded
            } else {
                print ("couldnt add items")
            }
        } catch NetworkError.invalidURL {
            print ("add items invalid URL")
        } catch NetworkError.invalidResponse {
            print ("add items invalid response")
        } catch NetworkError.unauthorized{
            AuthManager.shared.logout()
        } catch {
            print ("add items unexpected error")
        }
    }
}

