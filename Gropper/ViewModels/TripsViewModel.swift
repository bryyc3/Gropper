//
//  BaseTripsViewModel.swift
//  Gropper
//
//  Created by Bryce King on 11/12/25.
//

import Foundation
import Contacts
import SwiftUI

@MainActor
class TripsViewModel: ObservableObject {
    let userNumber: String
    @Published var hostedTrips: [TripInfo]?
    @Published var requestedTrips: [TripInfo]?

    private let socketService = SocketManagerService.shared
    
    var pendingHostedTrips: [TripInfo]? {hostedTrips?.filter{$0.status == nil}}
    var pendingRequestedTrips: [TripInfo]? {requestedTrips?.filter{$0.status == nil}}
    
    var confirmedHostedTrips: [TripInfo]? {hostedTrips?.filter{$0.status == 1}}
    var confirmedRequestedTrips: [TripInfo]? {requestedTrips?.filter{$0.status == 1}}
    
     init(){
        guard let phoneNumber = getItem(forKey: "userPhoneNumber") else {
            AuthManager.shared.logout()
            userNumber = ""
            return
        }
        userNumber = phoneNumber
        socketListener()
        Task{
             await retrieveTrips()
        }
    }
    
    func retrieveTrips() async {
        do{
            let request = TripData.getTrips(user: userNumber)
            let tripsResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: AllTrips.self)
            
            if let trips = tripsResponse {
                if var tripsHosted = trips.hostedTripData {
                    for (tripIndex, _) in tripsHosted.enumerated() {
                        for (requestorIndex, requestor) in tripsHosted[tripIndex].requestors.enumerated() {
                            tripsHosted[tripIndex].requestors[requestorIndex] = await retrieveContact(user: requestor)
                        }
                    }
                    self.hostedTrips = tripsHosted
                } else {
                    self.hostedTrips = nil
                }
                
                if var tripsRequested = trips.requestedTripData {
                    for (tripIndex, trip) in tripsRequested.enumerated() {
                        tripsRequested[tripIndex].host = await retrieveContact(user: trip.host)
                    }
                    self.requestedTrips = tripsRequested
                } else {
                    self.requestedTrips = nil
                }
            }// iterate through each type of trip and store contact info hosts and requestors
            
        } catch NetworkError.invalidURL {
            print ("Dash invalid URL")
        } catch NetworkError.invalidResponse {
            print ("Dash invalid response")
        } catch NetworkError.decodingError {
            print ("Dashboard decoding error")
        } catch NetworkError.unauthorized {
            AuthManager.shared.logout()
        } catch {
            print ("Dash unexpected error")
        }
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
    
    func acceptTrip(trip: String) async {
        do{
            let request = TripData.acceptTrip(tripId: trip)
            guard let tripAccepted = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if tripAccepted{
                print("Trip accepted")
            }
        } catch NetworkError.invalidURL {
            print ("Dash invalid URL")
        } catch NetworkError.invalidResponse {
            print ("Dash invalid response")
        } catch NetworkError.unauthorized {
            AuthManager.shared.logout()
        } catch {
            print ("Dash unexpected error")
        }
        
    }
    
    func deleteTrip(trip: String) async {
        do{
            let request = TripData.deleteTrip(tripId: trip)
            guard let tripDeleted = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self) else {
                throw NetworkError.invalidResponse
            }
            if tripDeleted {
                print("trip deleted")
            }
        } catch NetworkError.invalidURL {
            print ("Dash invalid URL")
        } catch NetworkError.invalidResponse {
            print ("Dash invalid response")
        } catch NetworkError.unauthorized {
            AuthManager.shared.logout()
        } catch {
            print ("Dash unexpected error")
        }
    }
    
    
    private func socketListener () {
        socketService.socket.on("newHostedTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTrip = data.first as? [String: Any] else {return}
            
            let tripId = newTrip["tripId"] as! String
            socketService.socket.emit("joinTrip", tripId)
        }//when host creates new trip, host joins the room
        
        socketService.socket.on("newRequest"){ [weak self] data, _ in
            guard let self else {return}
            guard let newRequestedTrip = data.first as? [String: Any] else {return}
            
            do{
                guard let newTrip = try socketService.handleData(receivedData: newRequestedTrip, type: TripInfo.self) else {return}
                
                if self.hostedTrips == nil {
                    let newTripArray: [TripInfo] = [newTrip]
                    self.hostedTrips = newTripArray
                } else {self.hostedTrips?.append(newTrip)}
                
                socketService.socket.emit("joinTrip", newTrip.tripId!)
            } catch WebsocketError.decodingError {
                print("websocket trip decoding error")
            } catch {
                print("unexpected trip websocket error")
            }
        }//when requestor requests a trip, add trip to hosted trip and have host join room for requested trip
        
        socketService.socket.on("newTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTripData = data.first as? [String: Any] else {return}
            do{
                guard let newTrip = try socketService.handleData(receivedData: newTripData, type: TripInfo.self) else {return}
                
                if self.requestedTrips == nil {
                    let newTripArray: [TripInfo] = [newTrip]
                    self.requestedTrips = newTripArray
                } else {self.requestedTrips?.append(newTrip)}
                
                socketService.socket.emit("joinTrip", newTrip.tripId!)
            } catch WebsocketError.decodingError {
                print("websocket trip decoding error")
            } catch {
                print("unexpected trip websocket error")
            }
        }//when host creates a trip add it to requestors array and add requestor to trip room
        
        
        socketService.socket.on("itemsAdded"){ [weak self] data, _ in
            guard let self else {return}
            guard let updatedTripData = data.first as? [String: Any] else {return}
            
            do{
                guard let updatedTrip = try socketService.handleData(receivedData: updatedTripData, type: TripInfo.self) else {return}
                if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == updatedTrip.tripId }) {
                    self.hostedTrips?[tripIndex] = updatedTrip
                }
            } catch WebsocketError.decodingError {
                print("websocket items decoding error")
            } catch {
                print("unexpected items websocket error")
            }
            
        }//update hosts UI with items a user added to a request
        
        socketService.socket.on("tripAccepted"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTripData = data.first as? [String: Any] else {return}
            
            do{
                guard let newTrip = try socketService.handleData(receivedData: newTripData, type: TripInfo.self) else {return}
                
                if newTrip.host.phoneNumber == self.userNumber {
                    if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == newTrip.tripId }) {
                        self.hostedTrips?[tripIndex] = newTrip
                    }
                } else {
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
        
        socketService.socket.on("tripDeleted"){ [weak self] data, _ in
            guard let self else {print("self err"); return}
            guard let tripData = data.first as? [String: Any] else {print("data err"); return}
            let tripId = tripData["tripId"] as! String
            do{
                self.hostedTrips?.removeAll(where: { $0.tripId == tripId })
                self.requestedTrips?.removeAll(where: { $0.tripId == tripId })
                
                if self.hostedTrips?.count == 0 {
                    self.hostedTrips = nil
                }
                if self.requestedTrips?.count == 0 {
                    self.requestedTrips = nil
                }
                
            } catch WebsocketError.decodingError {
                print("websocket trip decoding error")
            } catch {
                print("unexpected trip websocket error")
            }
        } //update trip array when a trip is accepted by the host
    }
}


