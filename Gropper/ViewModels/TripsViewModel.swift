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
         print(userNumber)
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
                }
                
                if var tripsRequested = trips.requestedTripData {
                    for (tripIndex, trip) in tripsRequested.enumerated() {
                        tripsRequested[tripIndex].host = await retrieveContact(user: trip.host)
                    }
                    self.requestedTrips = tripsRequested
                }
            } else {
                self.hostedTrips = nil
                self.requestedTrips = nil
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
    
    private func socketListener () {
        socketService.socket.on("newHostedTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTrip = data.first as? [String: Any] else {return}
            
            let tripId = newTrip["tripId"] as! String
            socketService.socket.emit("joinTrip", tripId)
        }
        
        socketService.socket.on("newTrip"){ [weak self] data, _ in
            guard let self else {return}
            guard let newTripData = data.first as? [String: Any] else {return}
            
            do{
                guard let newTrip = try socketService.handleData(receivedData: newTripData, type: TripInfo.self) else {return}
                self.requestedTrips?.append(newTrip)
                print("user \(userNumber): \(newTrip)")
            } catch WebsocketError.decodingError {
                print("websocket trip decoding error")
            } catch {
                print("unexpected trip websocket error")
            }
        }
        
        
        socketService.socket.on("itemsAdded"){ [weak self] data, _ in
            guard let self else {return}
            guard let itemsAddedData = data.first as? [String: Any] else {return}
            
            guard let tripId = itemsAddedData["trip"] as? String,
                  let requestorPhone = itemsAddedData["requestorPhone"] as? String,
                  let encodedItems = itemsAddedData["items"] else {print("returning"); return}
            
            do{
                guard let itemsAdded: [ItemInfo] = try socketService.handleData(receivedData: encodedItems, type: [ItemInfo].self) else {return}
                
                if let tripIndex = self.hostedTrips?.firstIndex(where: { $0.tripId == tripId }) {
                    if let requestorIndex = self.hostedTrips?[tripIndex].requestors.firstIndex(where: {$0.phoneNumber == requestorPhone}){
                        for item in itemsAdded{
                            if let emptyItemIndex = self.hostedTrips?[tripIndex].requestors[requestorIndex].itemsRequested?.firstIndex(where: {$0.itemName == " "}){
                                self.hostedTrips?[tripIndex].requestors[requestorIndex].itemsRequested?[emptyItemIndex] = item
                            } else {
                                self.hostedTrips?[tripIndex].requestors[requestorIndex].itemsRequested?.append(item)
                            }
                        }
                    }
                }
            } catch WebsocketError.decodingError {
                print("websocket items decoding error")
            } catch {
                print("unexpected items websocket error")
            }
            
        }
        
    }
}


