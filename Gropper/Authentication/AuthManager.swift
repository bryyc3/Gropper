//
//  AuthManager.swift
//  Gropper
//
//  Created by Bryce King on 7/18/25.
//

import Foundation

@MainActor
class AuthManager {
    static let shared = AuthManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let userPhone = "userPhoneNumber"
    
    
    func authStatus() -> Bool{
        guard getItem(forKey: refreshTokenKey) != nil else {
            return false
        }
        return true
    }
    
    func login(accessToken: String, refreshToken: String, phoneNumber: String) {
        Task{
            do{
                try storeItem(item: accessToken, forKey: accessTokenKey)
                try storeItem(item: refreshToken, forKey: refreshTokenKey)
                try storeItem(item: phoneNumber, forKey: userPhone)
            } catch KeychainError.unknown{
                print("Keychain error")
            }
            NotificationCenter.default.post(name: .login, object: nil)
        }
    }
    
    func logout() {
        Task{
            do{
                SocketManagerService.shared.disconnectSocket()
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
            } catch KeychainError.unknown{
                print("Keychain error")
            }
            NotificationCenter.default.post(name: .logout, object: nil)
        }
    }
}

extension Notification.Name {
    static let login = Notification.Name("login")
    static let logout = Notification.Name("logout")
}
