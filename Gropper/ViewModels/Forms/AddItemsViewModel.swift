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
            Task {
               try await AuthManager.shared.logout()
            }
            userNumber = ""
            return
        }
        userNumber = phoneNumber
    }
    
    func addItems(trip: String, tripHost: String) async throws -> ApiResponse {
        do{
            
            let request = TripData.updateItems(tripId: trip, host: tripHost, userPhone: userNumber, itemsRequested: items)
            
            guard let itemsAdded = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if(itemsAdded) {
                successfullyAdded = itemsAdded
            } else {
                return ApiResponse(status200: false, message: "Add Items Error - Couldn't Add Items")
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Add Items Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Add Items Error - Invalid Response")
        } catch NetworkError.unauthorized{
            do {
               try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Add Items Error - Unauthorized, Login Again")}
        } catch {
            return ApiResponse(status200: false, message: "Add Items Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
}

