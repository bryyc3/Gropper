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
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "create-trip",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["tripInfo": tripInformation,
                   "contacts": contacts]
        )
    }
    
    static func getTrips(user: String) -> TripData {
        return TripData(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "trips",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["user": user]
        )
    }
    
    static func updateItems(tripId: String, host: String, userPhone: String, itemsRequested: [ItemInfo]) -> TripData {
        return TripData(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "update-items",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["tripId": tripId,
                   "host": host,
                   "user": userPhone,
                   "items": itemsRequested]
        )
    }
    
    static func acceptTrip(tripId: String) -> TripData {
        return TripData(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "accept-trip",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["tripId": tripId]
        )
    }
    
    static func deleteTrip(tripId: String) -> TripData {
        return TripData(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "delete-trip",
            method: .delete,
            headers: ["Content-Type": "application/json"],
            body: ["tripId": tripId]
        )
    }
}
