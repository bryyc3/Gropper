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
            AuthManager.shared.logout()
            userNumber = ""
            return
        }
        userNumber = phoneNumber
    }
    
    func addRequestors(trip: String) async {
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
                print ("couldnt add items")
            }
        } catch NumberParseError.parseErr{
            print("Number Parse Error")
        } catch NetworkError.invalidURL {
            print ("add req invalid URL")
        } catch NetworkError.invalidResponse {
            print ("add req invalid response")
        } catch NetworkError.unauthorized{
            AuthManager.shared.logout()
        } catch {
            print ("add req unexpected error")
        }
    }
}
