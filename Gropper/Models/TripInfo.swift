//
//  TripInfo.swift
//  Gropper
//
//  Created by Bryce King on 5/6/25.
//

import Foundation


struct TripInfo: Codable{
    let tripId: String?
    var status: Bool?
    var location: String
    var date: String
    var time: String
    
    init(){
        location = ""
        date = ""
        time = ""
        tripId = nil
        status = nil
    }
}
