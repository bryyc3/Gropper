//
//  AuthenticationViewModel.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject{
    @Published var phoneNumber = ""
    @Published var otpCode = ""
    @Published var authenticated = false
    @Published var otpGenerated = false
    @Published var tokens = WebTokens()
    
    init(){
        self.tokens.refreshToken = getToken(forKey: "refreshToken")
        if self.tokens.refreshToken != nil{
            self.authenticated = true
        }
    }
    
    func requestOtp(){
        Task{
            do{
                otpGenerated = try await sendOtp(mobileNumber: phoneNumber)
            } catch SendOtp.encodingError{
                print("encoding error")
            } catch SendOtp.invalidURL {
                print ("invalid URL")
            } catch SendOtp.invalidResponse {
                print ("invalid response")
            } catch {
                print ("unexpected error")
            }
        }
    }
    
    func checkOtp(){
        Task{
            do{
                tokens = try await verifyOtp(mobileNumber: phoneNumber, otp: otpCode)
                if let refreshToken = tokens.refreshToken{
                    try storeToken(token: refreshToken, forKey: "refreshToken")
                }
                if let accessToken = tokens.accessToken{
                    try storeToken(token: accessToken, forKey: "accessToken")
                }
                
            } catch VerifyOtp.encodingError {
                print("encoding error")
            } catch VerifyOtp.invalidURL {
                print ("invalid URL")
            } catch VerifyOtp.invalidResponse {
                print ("invalid response")
            } catch VerifyOtp.decodingError {
                print ("decoding error")
            } catch {
                print ("unexpected error")
            }
            authenticated = true
        }
    }
}
