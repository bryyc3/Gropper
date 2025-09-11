//
//  ContactStore.swift
//  Gropper
//
//  Created by Bryce King on 7/26/25.
//

import Foundation
import Contacts

func getContact(for userContact: ContactInfo) -> ContactInfo {
    let phoneNumber = userContact.phoneNumber.digitsOnly
    
   
    let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phoneNumber))
    
    let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor]
    
    do{
        let contact = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keys).first!
        
        var newUserContact = userContact
        
        newUserContact.contactName = contact.givenName + " " + contact.familyName
        newUserContact.contactPhoto = contact.thumbnailImageData
        
        return newUserContact
    } catch {
        return userContact
    }
}

extension String {
    var digitsOnly: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

