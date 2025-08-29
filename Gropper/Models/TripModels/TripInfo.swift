//
//  TripInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/6/25.
//

import Foundation


struct TripInfo: Codable{
    var id = UUID()
    var tripId: String?
    var host: String = ""
    var status: Int?
    var location: String = ""
    var locationDescription: String = ""
    var date: String?
    var time: String?
    
    var requestors: [RequestorInfo] = []
    
    enum CodingKeys: String, CodingKey {
        case tripId
        case host
        case status
        case location
        case locationDescription
        case date
        case time
        case requestors
    }
}
