//
//  CreateTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/12/25.
//

import SwiftUI
import ContactsUI

struct CreateTripView: View {
    @State var location: String = ""
    @State var selectedContacts: [CNContact]?
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        Form{
            TextField("Location", text: $location )
            Button("Select Contacts"){
                presentContactPicker()
            }
            HStack{
                if let displayedContacts = selectedContacts {
                    List(displayedContacts) { contact in
                        Text("\(contact.givenName) \(contact.familyName)")
                    }
                } else{
                    Text("No Contacts Selected")
                }
            }
            .onReceive(coordinator.$selectedContacts, perform: { contactsArray in self.selectedContacts = contactsArray})//once user selects contact update UI variable
        }
        Button("Create Trip"){
            
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
        @Published var selectedContacts: [CNContact]?
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
            if(contacts.count > 0){
                selectedContacts = contacts
            }
            else {
                return
            }
           
        }
    }

}

#Preview {
    CreateTripView()
}
