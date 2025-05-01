//
//  RequestTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/30/25.
//

import SwiftUI
import ContactsUI

struct RequestedItem: Hashable, Identifiable {
    let id = UUID()
    var name: String
    var description: String
}


struct RequestTripView: View {
    @State var requestLocation: String = ""
    @State var itemsRequested: [RequestedItem] = []
    @State var selectedContact: CNContact?
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        Form{
            VStack{
                if let displayedContact = selectedContact {
                    Text("\(displayedContact.givenName) \(displayedContact.familyName)")
                } else{
                    Text("No Contacts Selected")
                }
            }
            .onReceive(coordinator.$selectedContact, perform: { contactInfo in self.selectedContact = contactInfo})//once user selects contact update UI variable
        
            Button("Select Contact"){
                presentContactPicker()
            }
            
            TextField("Location", text:$requestLocation)
            
            if(itemsRequested.count > 0){
                RequestItemsListView(itemsArray: $itemsRequested)
            }
            Button("Add Item"){
                itemsRequested.append(RequestedItem(name: "", description: ""))
            }
        }
        Button("Submit Request"){
            
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
        @Published var selectedContact: CNContact?
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
            if(contact.givenName != ""){
                selectedContact = contact
            }
            else {
                return
            }
           
        }
    }
}

#Preview {
    RequestTripView()
}
