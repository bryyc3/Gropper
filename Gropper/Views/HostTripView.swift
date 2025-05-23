//
//  HostTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/12/25.
//

import SwiftUI
import ContactsUI

struct HostTripView: View {
    @Environment(\.dismiss) var dismiss
    @State var tripData = TripInfo()
    @State var selectedContacts: [ContactInfo] = []
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Where Are You Going?")){
                    TextField("Location", text: $tripData.location )
                    TextField("Location Description", text: $tripData.locationDescription)
                }
                Section(header: Text("Who can request items?")){
                    HStack{
                        if (selectedContacts.count > 0) {
                            List(selectedContacts, id: \.phoneNumber) { contact in
                                Text("\(contact.firstName) \(contact.lastName ?? "")")
                            }
                        } else{
                            Text("No Contacts Selected")
                        }
                    }
                    Button("Select Contacts"){
                        presentContactPicker()
                    }
                }
                
                .onReceive(coordinator.$selectedContacts, perform: { contactsArray in self.selectedContacts = contactsArray})//once user selects contact update UI variable
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    createHostedTrip()
                    dismiss()
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
    
    func createHostedTrip(){
        tripData.status = true
        tripData.host = "1111111111"
        tripData.tripId = UUID().uuidString
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
         }
    }//create trip
    
    
    class Coordinator: NSObject, ObservableObject, CNContactPickerDelegate {
        @Published var selectedContacts: [ContactInfo] = []
        var contactArray: [ContactInfo] = []
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
            selectedContacts = []
            contactArray = []
            if(contacts.isEmpty){
                return
            }
            else {
                for contact in contacts {
                    var contactInfo = ContactInfo()
                    contactInfo.firstName = contact.givenName
                    contactInfo.lastName =  contact.familyName
                    contactInfo.phoneNumber =  contact.phoneNumbers.first?.value.stringValue ?? ""
                    contactArray.append(contactInfo)
                }
                selectedContacts = contactArray
            }
           
        }
    }

}

#Preview {
    HostTripView()
}
