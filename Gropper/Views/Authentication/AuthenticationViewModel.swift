//
//  AuthenticationViewModel.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject{
    //@Published var user = UserInfo()
    @Published var phoneNumber = ""
    @Published var otpCode = ""
    @Published var authenticated = false
    @Published var tokens = WebTokens()
    @Published var otpGenerated = false
    
    init(){
        self.tokens.refreshToken = getToken(forKey: "refreshToken")
        if self.tokens.refreshToken != nil{
            self.authenticated = true
        }
    }
    
    func requestOtp(){
        Task{
            do{
                let request = Authentication.sendOtp(mobileNumber: phoneNumber)
                otpGenerated = try await NetworkManager.shared.execute(endpoint: request, type: Bool.self) ?? false
                
            } catch BuildRequestError.encodingError{
                print("encoding error")
            } catch NetworkError.invalidURL {
                print ("invalid URL")
            } catch NetworkError.invalidResponse {
                print ("invalid response")
            } catch {
                print ("unexpected error")
            }
        }
    }
    
    func checkOtp(){
        Task{
            do{
                let request = Authentication.verifyOtp(mobileNumber: phoneNumber, otp: otpCode)
                tokens = try await NetworkManager.shared.execute(endpoint: request, type: WebTokens.self) ?? WebTokens()
                
                if let refreshToken = tokens.refreshToken{
                    try storeToken(token: refreshToken, forKey: "refreshToken")
                }
                if let accessToken = tokens.accessToken{
                    try storeToken(token: accessToken, forKey: "accessToken")
                }
                
                resetUser()
            } catch BuildRequestError.encodingError {
                print("encoding error")
            } catch NetworkError.invalidURL {
                print ("invalid URL")
            } catch NetworkError.invalidResponse {
                print ("invalid response")
            } catch NetworkError.decodingError {
                print ("decoding error")
            } catch {
                print ("unexpected error")
            }
            authenticated = true
        }
    }
    
    func resetUser(){
        phoneNumber = ""
        otpCode = ""
        otpGenerated = false
    }
}
