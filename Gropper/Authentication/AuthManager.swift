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
    private let notiToken = "notificationToken"
    
    
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
    
    func logout() async throws -> Bool{
        do{
            guard let userNumber = try getItem(forKey: userPhone), let notificationToken = try getItem (forKey: notiToken) else {
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
                NotificationCenter.default.post(name: .logout, object: nil)
                return true
            }
            
            let request = Authentication.logout(phoneNumber: userNumber, deviceToken: notificationToken)
            let logoutResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self)
            
            if(logoutResponse == true) {
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
            } else {
                return false
            }
        } catch KeychainError.unknown{
            print("Keychain error")
        } catch {
            print("Logout Error")
        }
        NotificationCenter.default.post(name: .logout, object: nil)
        return true
    }
}

extension Notification.Name {
    static let login = Notification.Name("login")
    static let logout = Notification.Name("logout")
}
