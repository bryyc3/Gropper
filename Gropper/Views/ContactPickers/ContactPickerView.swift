//
//  ContactPickerView.swift
//  Gropper
//
//  Created by Bryce King on 5/29/25.
//

import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    var onSelectContact: (ContactInfo) -> Void
    var onCancel: () -> Void
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView
        var contactInfo = ContactInfo()
        
        init(parent: ContactPickerView){
            self.parent = parent
        }
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
            contactInfo.firstName = contact.givenName
            contactInfo.lastName = contact.familyName
            contactInfo.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            parent.onSelectContact(contactInfo)
        }
        
    }
    
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
}

