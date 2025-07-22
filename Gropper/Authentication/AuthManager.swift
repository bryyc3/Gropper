//
//  AuthManager.swift
//  Gropper
//
//  Created by Bryce King on 7/18/25.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    
    func authStatus() -> Bool{
        guard getToken(forKey: "refreshToken") != nil else {
            return false
        }
        return true
    }
    
    func login(accessToken: String, refreshToken: String) {
        Task{
            do{
                try storeToken(token: accessToken, forKey: accessTokenKey)
                try storeToken(token: refreshToken, forKey: refreshTokenKey)
            } catch KeychainError.unknown{
                print("Keychain error")
            }
            NotificationCenter.default.post(name: .login, object: nil)
        }
    }
    
    func logout() {
        Task{
            do{
                try deleteToken(forKey: "accessToken")
                try deleteToken(forKey: "refreshToken")
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
