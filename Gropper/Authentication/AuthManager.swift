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
    
    func logout() async throws -> ApiResponse {
        do{
            guard let userNumber = try getItem(forKey: userPhone), let notificationToken = try getItem(forKey: notiToken) else {
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
                NotificationCenter.default.post(name: .logout, object: nil)
                return ApiResponse(status200: true, message: nil)
            }
            
            let request = Authentication.logout(phoneNumber: userNumber, deviceToken: notificationToken)
            let logoutResponse = try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self)
            
            if(logoutResponse == true) {
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
            } else {
                return ApiResponse(status200: false, message: "Error Logging Out - Invalid response from server")
            }
        } catch KeychainError.unknown{
            return ApiResponse(status200: false, message: "Logout Keychain Error - Unknown")
        } catch {
            return ApiResponse(status200: false, message: "Unknown Logout Error")
        }
        NotificationCenter.default.post(name: .logout, object: nil)
        return ApiResponse(status200: true, message: nil)
    }
    
    func deleteAccount() async throws -> ApiResponse {
        do{
            guard let userNumber = try getItem(forKey: userPhone) else {
                return ApiResponse(status200: false, message: "No Phone Number Associated With Device to Delete")
            }
            
            let deleteAccountRequest = Authentication.deleteAccount(phoneNumber: userNumber)
            let deleteAccountResponse = try await NetworkManager.shared.execute(endpoint: deleteAccountRequest, auth: true, type: Bool.self)
            
            if(deleteAccountResponse == true) {
                try deleteToken(forKey: accessTokenKey)
                try deleteToken(forKey: refreshTokenKey)
                try deleteToken(forKey: userPhone)
            } else {
                return ApiResponse(status200: false, message: "Delete Account Failed - Server Error Removing Account from APNs")
            }
        } catch KeychainError.unknown{
            return ApiResponse(status200: false, message: "Keychain Logout Unknown Error")
        } catch {
            return ApiResponse(status200: false, message: "Unknown Logout Error")
        }
        NotificationCenter.default.post(name: .logout, object: nil)
        return ApiResponse(status200: true, message: nil)
    }
}

extension Notification.Name {
    static let login = Notification.Name("login")
    static let logout = Notification.Name("logout")
}
