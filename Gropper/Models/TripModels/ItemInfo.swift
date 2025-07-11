//
//  ItemInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/7/25.
//

import Foundation

struct ItemInfo: Identifiable, Codable{
    var id: UUID = UUID()
    var itemName: String
    var itemDescription: String
    var requestor: String
    
    enum CodingKeys: CodingKey {
            case itemName
            case itemDescription
            case requestor
    }
    
    init(requestor: String){
        itemName = ""
        itemDescription = ""
        self.requestor = requestor
    }
}
