//
//  BaseTripsViewModel.swift
//  Gropper
//
//  Created by Bryce King on 11/12/25.
//

import Foundation
import Contacts
import SwiftUI
import UserNotifications

@MainActor
class TripsViewModel: ObservableObject {
    @Published var userNumber = ""
    @Published var hostedTrips: [TripInfo]?
    @Published var requestedTrips: [TripInfo]?
    
    var pendingHostedTrips: [TripInfo]? {hostedTrips?.filter{$0.status == nil}}
    var pendingRequestedTrips: [TripInfo]? {requestedTrips?.filter{$0.status == nil}}
    
    var confirmedHostedTrips: [TripInfo]? {hostedTrips?.filter{$0.status == 1}}
    var confirmedRequestedTrips: [TripInfo]? {requestedTrips?.filter{$0.status == 1}}
    
    init() {
        guard let phoneNumber = getItem(forKey: "userPhoneNumber") else {
            Task {
                try await AuthManager.shared.logout()
                userNumber = ""
            }
            return
        }
        self.userNumber = phoneNumber
        socketListener()
        Task{
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                if granted {
                    await MainActor.run {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                try await retrieveTrips()
            } catch {
                print("notification access request err")
            }
        }
    }
    
    func retrieveTrips() async throws -> ApiResponse {
        do{
            let request = TripData.getTrips(user: userNumber)
            let tripsResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: AllTrips.self)
            
            if let trips = tripsResponse {
                if var tripsHosted = trips.hostedTripData {
                    for (tripIndex, _) in tripsHosted.enumerated() {
                        for (requestorIndex, requestor) in tripsHosted[tripIndex].requestors.enumerated() {
                            tripsHosted[tripIndex].requestors[requestorIndex] = await retrieveContact(user: requestor)
                        }
                        
                        SocketManagerService.shared.socket.emit("joinTrip", tripsHosted[tripIndex].tripId!)
                    }
                    self.hostedTrips = tripsHosted
                } else {
                    self.hostedTrips = nil
                }
                
                if var tripsRequested = trips.requestedTripData {
                    for (tripIndex, trip) in tripsRequested.enumerated() {
                        tripsRequested[tripIndex].host = await retrieveContact(user: trip.host)
                        SocketManagerService.shared.socket.emit("joinTrip", trip.tripId!)
                    }
                    self.requestedTrips = tripsRequested
                } else {
                    self.requestedTrips = nil
                }
            }// iterate through each type of trip and store contact info hosts and requestors
            
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Retrieve Trips Error - Unable to Reach Endpoint")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Retrieve Trips Error - Invalid Response")
        } catch NetworkError.decodingError {
            return ApiResponse(status200: false, message: "Retrieve Trips Error - Unable to Decode Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Retrieve Trips Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Retrieve Trips Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func retrieveContact(user: ContactInfo) async -> ContactInfo{
        let access = CNContactStore.authorizationStatus(for: .contacts)
        
        switch access {
            case .authorized:
                return getContact(for: user)

            case .notDetermined:
                let granted = await requestContactAccess()
                return granted ? getContact(for: user) : user
                
            case .denied, .restricted, .limited:
                return user
                
            @unknown default:
                return user
        }
    }//determine access to contacts and carry out appropriate function based on user selection
    
    func requestContactAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }//request for access to contacts
    
    func acceptTrip(trip: String) async throws -> ApiResponse {
        do{
            let request = TripData.acceptTrip(tripId: trip)
            guard let tripAccepted = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Accept Trip Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Accept Trip Error - Invalid Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Accept Trip Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Accept Trip Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func deleteTrip(trip: String) async throws -> ApiResponse {
        do{
            let request = TripData.deleteTrip(tripId: trip)
            guard let tripDeleted = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else { throw NetworkError.invalidResponse
            }
            
            if tripDeleted {
                self.hostedTrips?.removeAll(where: { $0.tripId == trip })
            } else {
                return ApiResponse(status200: false, message: "Delete Trip Error - Couldnt Delete Trip")
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Delete Trip Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Delete Trip Error - Invalid Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Delete Trip Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Delete Trip Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func removeRequestor(requestorInfo: String, trip: String) async throws -> ApiResponse {
        do{
            let request = TripData.removeRequestor(requestor: requestorInfo, tripId: trip)
            guard let requestorRemoved = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if requestorRemoved {
                if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == trip}) {
                    self.hostedTrips?[tripIndex].requestors.removeAll(where: {$0.phoneNumber == requestorInfo})
                }
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Remove Requestor Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Remove Requestor Error - Invalid Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Remove Requestor Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Remove Requestor Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func deleteItem(trip: String, itemName: String, itemsAmount: Int) async throws -> ApiResponse {
        do{
            let request = TripData.deleteItem(tripId: trip, item: itemName, user: userNumber, itemsCount: itemsAmount)
            guard let itemDeleted = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: TripInfo.self) else {
                throw NetworkError.invalidResponse
            }
            if let tripIndex = self.requestedTrips?.firstIndex(where: { $0.tripId == itemDeleted.tripId }) {
                self.requestedTrips?[tripIndex] = itemDeleted
                print("item deleted")
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Item Deletion Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Item Deletion Error - Invalid Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Item Deletion Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Item Deletion Error - Unexpected Error")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func deleteAccountData() async throws -> ApiResponse{
        do{
            for trip in requestedTrips ?? [] {
                 try await removeRequestor(requestorInfo: userNumber, trip: trip.tripId!)
            }
            for trip in hostedTrips ?? [] {
                 try await deleteTrip(trip: trip.tripId!)
            }
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Item Deletion Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Item Deletion Error - Invalid Response")
        } catch NetworkError.unauthorized {
            do {
                try await AuthManager.shared.logout()
            } catch {return ApiResponse(status200: false, message: "Item Deletion Error - Unauthorized, login again")}
        } catch {
            return ApiResponse(status200: false, message: "Item Deletion Error - Unexpected Error")
        }
        return try await AuthManager.shared.deleteAccount()
    }
    
    private func socketListener() {
        let socket = SocketManagerService.shared.socket
        
        socket.off("newHostedTrip")
        socket.off("newRequest")
        socket.off("newTrip")
        socket.off("itemsAdded")
        socket.off("itemDeleted")
        socket.off("tripAccepted")
        socket.off("tripDeleted")
        
        socket.on("newHostedTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTrip = data.first as? [String: Any] else {return}
            
            let tripId = newTrip["tripId"] as! String
            socket.emit("joinTrip", tripId)
        }//when host creates new trip, host joins the room
        
        socket.on("newRequest"){ [weak self] data, _ in
            guard let self else {return}
            guard let newRequestedTrip = data.first as? [String: Any] else {return}
            do{
                guard let newTrip = try SocketManagerService.shared.handleData(receivedData: newRequestedTrip, type: TripInfo.self) else {return}
                
                self.hostedTrips?.append(newTrip)
                
                socket.emit("joinTrip", newTrip.tripId!)
            } catch WebsocketError.decodingError {
                print("websocket new req decoding error")
            } catch {
                print("unexpected new req websocket error")
            }
        }//when requestor requests a trip, add trip to hosted trip and have host join room for requested trip
        
        socket.on("newTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTripData = data.first as? [String: Any] else {return}
            print("adding trip")
            Task{
                do{
                    guard var newTrip = try SocketManagerService.shared.handleData(receivedData: newTripData, type: TripInfo.self) else {return}
                    newTrip.host = await self.retrieveContact(user: newTrip.host)
                    
                    if self.requestedTrips == nil {
                        self.requestedTrips = [newTrip]
                    } else {self.requestedTrips?.append(newTrip)}
                    
                    socket.emit("joinTrip", newTrip.tripId!)
                } catch WebsocketError.decodingError {
                    print("websocket new trip decoding error")
                } catch {
                    print("unexpected new trip websocket error")
                }
            }
        }//when host creates a trip add it to requestors array and add requestor to trip room
        
        
        socket.on("itemsAdded"){ [weak self] data, _ in
            guard let self else {return}
            guard let updatedTripData = data.first as? [String: Any] else {return}
            
            Task{
                do{
                    guard var updatedTrip = try  SocketManagerService.shared.handleData(receivedData: updatedTripData, type: TripInfo.self) else {return}
                    for (requestorIndex, requestor) in updatedTrip.requestors.enumerated() {
                        updatedTrip.requestors[requestorIndex] = await self.retrieveContact(user: requestor)
                    }
                    
                    if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == updatedTrip.tripId }) {
                        self.hostedTrips?[tripIndex] = updatedTrip
                    }
                } catch WebsocketError.decodingError {
                    print("websocket items decoding error")
                } catch {
                    print("unexpected items websocket error")
                }
            }
            
        }//update hosts UI with items a user added to a request
        
        socket.on("itemDeleted"){ [weak self] data, _ in
            guard let self else {return}
            guard let updatedTripData = data.first as? [String: Any] else {return}
            Task{
                do{
                    print("deleting item")
                    guard var updatedTrip = try  SocketManagerService.shared.handleData(receivedData: updatedTripData, type: TripInfo.self) else {return}
                    for (requestorIndex, requestor) in updatedTrip.requestors.enumerated() {
                        updatedTrip.requestors[requestorIndex] = await self.retrieveContact(user: requestor)
                    }
                    
                    if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == updatedTrip.tripId }) {
                        self.hostedTrips?[tripIndex] = updatedTrip
                        print("item deleted")
                    } else {
                        print("failed")
                    }
                } catch WebsocketError.decodingError {
                    print("websocket items deleted decoding error")
                } catch {
                    print("unexpected items deleted websocket error")
                }
            }
            
        }//update hosts UI with items a user added to a request
        
        socket.on("tripAccepted"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTripData = data.first as? [String: Any] else {return}
            print("running accepted trip")
            Task{
                do{
                    guard var newTrip = try  SocketManagerService.shared.handleData(receivedData: newTripData, type: TripInfo.self) else {return}
                    
                    if newTrip.host.phoneNumber == self.userNumber {
                        for (requestorIndex, requestor) in newTrip.requestors.enumerated() {
                            newTrip.requestors[requestorIndex] = await self.retrieveContact(user: requestor)
                        }
                        if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == newTrip.tripId }) {
                            self.hostedTrips?[tripIndex] = newTrip
                        }
                    } else {
                        newTrip.host = await self.retrieveContact(user: newTrip.host)
                        if let tripIndex = self.requestedTrips?.firstIndex(where: { $0.tripId == newTrip.tripId }) {
                            self.requestedTrips?[tripIndex] = newTrip
                        }
                    }//determine which array (hosted or requested) to add the confirmed trip
                    
                } catch WebsocketError.decodingError {
                    print("websocket trip decoding error")
                } catch {
                    print("unexpected trip websocket error")
                }
            }
        }
        
        socket.on("tripDeleted") { [weak self] data, _ in
            guard let self else {print("self err"); return}
            guard let tripData = data.first as? [String: Any] else {print("data err"); return}
            let tripId = tripData["tripId"] as! String
            
            self.requestedTrips?.removeAll(where: { $0.tripId == tripId })
            
            if self.requestedTrips?.count == 0 {
                self.requestedTrips = nil
            }
            print("trip socket deleted")
        } //update trip array when a trip is deleted
    }
}


