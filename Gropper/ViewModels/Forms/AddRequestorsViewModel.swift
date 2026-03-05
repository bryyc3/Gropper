//
//  AddRequestorsViewModel.swift
//  Gropper
//
//  Created by Bryce King on 12/16/25.
//

import Foundation

@MainActor
class AddRequestorsViewModel: NSObject, ObservableObject {
    let userNumber: String
    
    @Published var selectedContacts: [ContactInfo] = []
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
    
    func addRequestors(trip: String) async throws -> ApiResponse {
        do{
            for (index, requestor) in selectedContacts.enumerated() {
                guard let requestorNumber = try? NumberParse(number: requestor.phoneNumber) else {
                    throw NumberParseError.parseErr
                }
                selectedContacts[index].phoneNumber = requestorNumber
            }//parse requestor numbers
            
            let request = TripData.newRequestors(tripId: trip, contacts: selectedContacts)
            
            guard let requestorsAdded = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if(requestorsAdded) {
                successfullyAdded = requestorsAdded
            } else {
                return ApiResponse(status200: false, message: "Add Requestors Error - Failed to Add Requestors")
            }
        } catch NumberParseError.parseErr{
            return ApiResponse(status200: false, message: "Add Requestors Error - Unable to Parse Phone Number, Try Again")
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Add Requestors Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Add Requestors Error - Invalid Response")
        } catch NetworkError.unauthorized{
            do {
               try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Add Requestors Error - Unauthorized, please log back in")}
        } catch {
            return ApiResponse(status200: false, message: "Add Requestors Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
}
