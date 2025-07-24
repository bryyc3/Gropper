//
//  TripInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/6/25.
//

import Foundation


struct TripInfo: Codable{
    var tripId: String?
    var host: String = ""
    var status: Int?
    var location: String = ""
    var locationDescription: String = ""
    var date: String?
    var time: String?
    
    var requestors: [RequestorInfo] = []
}
