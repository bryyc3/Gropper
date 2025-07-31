//
//  ContactStore.swift
//  Gropper
//
//  Created by Bryce King on 7/26/25.
//

import Foundation
import Contacts

func getContact(for requestor: RequestorInfo) -> RequestorInfo {
    let phoneNumber = requestor.phoneNumber.digitsOnly
    
   
    let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phoneNumber))
    
    let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor]
    
    do{
        let contact = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keys).first!
        
        var newRequestor = requestor
        
        newRequestor.contactName = contact.givenName
        newRequestor.contactPhoto = contact.thumbnailImageData
        
        return newRequestor
    } catch {
        return requestor
    }
}

extension String {
    var digitsOnly: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

