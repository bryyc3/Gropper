//
//  ContactInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/11/25.
//

import Foundation
import SwiftUI

struct ContactInfo: Codable{
    var firstName: String = ""
    var lastName: String?
    var phoneNumber: String = ""
}

func imageData(info: Data?) -> UIImage{
    if let imageData = info, let contactPhoto = UIImage(data: imageData){
        return contactPhoto
    } else {
        return UIImage(systemName: "person.circle")!
    }
}
