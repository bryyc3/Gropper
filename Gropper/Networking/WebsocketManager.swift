//
//  WebsocketManager.swift
//  Gropper
//
//  Created by Bryce King on 9/26/25.
//

import Foundation
import SocketIO


class SocketManagerService {
    static let shared = SocketManagerService()
       
    private let manager: SocketManager
    let socket: SocketIOClient
       
    private init() {
        let token = getItem(forKey: "refreshToken") ?? ""
        manager = SocketManager(socketURL: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!, config: [.log(true), .compress, .extraHeaders(["Authorization": "Bearer \(token)"])])
        socket = manager.defaultSocket
        socket.connect()
        print("connected to socket")
    }
    
    func disconnectSocket(){
        socket.disconnect()
    }
    
    func handleData<T: Decodable>(receivedData: Any, type: T.Type) throws ->  T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: receivedData)
            let decoded = try JSONDecoder().decode(T.self, from: jsonData)
            print(decoded)
            return decoded
        } catch {
           throw WebsocketError.decodingError
        }
    }
    
    func emit(event: String, tripId: String){
        socket.emit(event, tripId)
    }
}
