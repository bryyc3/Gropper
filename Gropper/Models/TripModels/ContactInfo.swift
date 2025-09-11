//
//  ContactInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/11/25.
//

import Foundation
import SwiftUI

struct ContactInfo: Codable{
    var phoneNumber: String
    var contactName: String?
    var contactPhoto: Data?
    var itemsRequested: [ItemInfo]?
    
    enum CodingKeys: CodingKey {
            case phoneNumber, itemsRequested
    }
}

func imageData(info: Data?) -> UIImage?{
    if let imageData = info, let contactPhoto = UIImage(data: imageData){
        return contactPhoto
    } else {
        return nil
    }
}
