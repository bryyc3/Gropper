//
//  CreateTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/12/25.
//

import SwiftUI
import ContactsUI

struct CreateTripView: View {
    @Environment(\.dismiss) var dismiss
    @State var tripData = TripInfo()
    @State var selectedContacts: [ContactInfo] = []
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            Form{
                TextField("Location", text: $tripData.location )
                
                Button("Select Contacts"){
                    presentContactPicker()
                }
                HStack{
                    if (selectedContacts.count > 0) {
                        List(selectedContacts, id: \.phoneNumber) { contact in
                            Text("\(contact.firstName) \(contact.lastName ?? "")")
                        }
                    } else{
                        Text("No Contacts Selected")
                    }
                }
                .onReceive(coordinator.$selectedContacts, perform: { contactsArray in self.selectedContacts = contactsArray})//once user selects contact update UI variable
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    tripData.status = true
                    //dismiss()
                    Task{
                        do{
                            try await createTrip(tripInformation: tripData, contacts: selectedContacts)
                        } catch TripCreationError.invalidURL {
                            print ("invalid URL")
                        }  catch TripCreationError.invalidResponse {
                            print ("invalid response")
                        } catch {
                            print ("unexpected error")
                        }
                     }//create trip
                }
                .disabled(tripData.location.isEmpty || selectedContacts.isEmpty)
            }
        }
    }
    
    func presentContactPicker() {
        let contactPickerVC = CNContactPickerViewController()
        contactPickerVC.delegate = coordinator
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window?.rootViewController?.present(contactPickerVC, animated: true)
    }
    
    
    class Coordinator: NSObject, ObservableObject, CNContactPickerDelegate {
        @Published var selectedContacts: [ContactInfo] = []
        var contactArray: [ContactInfo] = []
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
            if(contacts.count > 0){
                contactArray = []
                for contact in contacts {
                    let contactInfo = ContactInfo(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "")
                    contactArray.append(contactInfo)
                }
                selectedContacts = contactArray
            }
            else {
                selectedContacts = []
            }
           
        }
    }

}

#Preview {
    CreateTripView()
}
