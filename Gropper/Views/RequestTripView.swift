//
//  RequestTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/30/25.
//

import SwiftUI
import ContactsUI

struct RequestTripView: View {
    @Environment(\.dismiss) var dismiss
    @State var tripData = TripInfo()
    @State var items: [ItemInfo] = []
    @State var hostContact = ContactInfo()
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Where Do You need Items From?")){
                    TextField("Location", text: $tripData.location )
                    TextField("Location Description", text: $tripData.locationDescription)
                }
                Section(header: Text("Who's The Request For?")){
                    if(!hostContact.phoneNumber.isEmpty) {
                        Text("\(hostContact.firstName) \(hostContact.lastName ?? "")")
                    } else{
                        Text("No Contact Selected")
                    }
                    Button("Select Contact"){
                        presentContactPicker()
                    }
                }
                .onReceive(coordinator.$hostContact, perform: { hostContactInfo in self.hostContact = hostContactInfo})//once user selects contact update UI variable
            
                Section(header: Text("What Do You need?")){
                    if (items.count > 0) {
                        List($items){$item in
                            TextField("Item Name", text: $item.itemName)
                            TextField("Item Description", text: $item.itemDescription)
                        }
                        
                    } else{
                        Section{
                            Text("No Items")
                        }
                    }
                    Button("Add Item"){
                        items.append(ItemInfo(requestor: "1111111111"))
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    requestTrip()
                    dismiss()
                }
                .disabled(tripData.location.isEmpty || hostContact.phoneNumber.isEmpty)
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
    
    func requestTrip(){
        tripData.host = hostContact.phoneNumber
        tripData.itemsRequested = items
        tripData.tripId = UUID().uuidString
        Task{
            do{
                try await createTrip(tripInformation: tripData, contacts: nil)
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
        @Published var hostContact = ContactInfo()
        var selectedContact = ContactInfo()
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
            selectedContact.firstName = contact.givenName
            selectedContact.lastName = contact.familyName
            selectedContact.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            
            hostContact = selectedContact
        }
    }
}

#Preview {
    RequestTripView()
}
