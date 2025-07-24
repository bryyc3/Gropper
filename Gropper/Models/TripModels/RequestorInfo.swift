//
//  RequestorInfo.swift
//  Gropper
//
//  Created by Bryce King on 7/23/25.
//

import Foundation

struct RequestorInfo: Codable {
    var phoneNumber: String
    var itemsRequested: [ItemInfo]
}
