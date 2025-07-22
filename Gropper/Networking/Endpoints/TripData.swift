//
//  TripData.swift
//  Gropper
//
//  Created by Bryce King on 7/8/25.
//

import Foundation

struct TripData: Endpoint {
    var baseUrl: URL
    var path: String
    var method: HttpMethod
    var headers: [String: String]?
    var body: [String: Encodable]?
   
    static func createTrip(tripInformation: TripInfo, contacts: [ContactInfo]?) -> TripData {
        return TripData(
            baseUrl: URL(string: "http://localhost:8080/")!,
            path: "create-trip",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["tripInfo": tripInformation,
                   "contacts": contacts]
        )
    }
    
    static func getTrips() -> TripData {
        return TripData(
            baseUrl: URL(string: "http://localhost:8080/")!,
            path: "trips",
            method: .get
        )
    }
}
