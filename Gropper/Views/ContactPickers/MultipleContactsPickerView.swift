//
//  MultipleContactsPickerView.swift
//  Gropper
//
//  Created by Bryce King on 5/30/25.
//
import SwiftUI
import ContactsUI

struct MultipleContactsPickerView: UIViewControllerRepresentable {
    var onSelectContacts: ([ContactInfo]) -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navController = UINavigationController()
        let contactPickerVC = CNContactPickerViewController()
        contactPickerVC.delegate = context.coordinator
        navController.pushViewController(contactPickerVC, animated: false)
        navController.isNavigationBarHidden = true
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: MultipleContactsPickerView
        var contactsArray: [ContactInfo] = []
        
        init(parent: MultipleContactsPickerView){
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
            contactsArray = []
            if(!contacts.isEmpty){
                for contact in contacts {
                    var contactInfo = ContactInfo()
                    contactInfo.firstName = contact.givenName
                    contactInfo.lastName =  contact.familyName
                    contactInfo.phoneNumber =  contact.phoneNumbers.first?.value.stringValue ?? ""
                    contactsArray.append(contactInfo)
                }
                self.parent.onSelectContacts(contactsArray)
            }
        }
    }
}
