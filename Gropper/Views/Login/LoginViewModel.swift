//
//  LoginViewModel.swift
//  Gropper
//
//  Created by Bryce King on 7/21/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject{
    @Published var user = UserInfo()
    
    func requestOtp(){
        Task{
            do{
                let request = Authentication.sendOtp(mobileNumber: user.phoneNumber)
                user.otpGenerated = try await NetworkManager.shared.execute(endpoint: request, auth: false, type: Bool.self) ?? false
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
                let request = Authentication.verifyOtp(mobileNumber: user.phoneNumber, otp: user.otpCode)
                let tokens = try await NetworkManager.shared.execute(endpoint: request, auth: false, type: WebTokens.self) ?? WebTokens()
                
                guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else {
                    throw NetworkError.decodingError
                }
                AuthManager.shared.login(accessToken: accessToken, refreshToken: refreshToken, phoneNumber: user.phoneNumber)
                resetUser()
            } catch BuildRequestError.encodingError {
                print("Auth encoding error")
            } catch NetworkError.invalidURL {
                print ("Auth invalid URL")
            } catch NetworkError.invalidResponse {
                print ("Auth invalid response")
            } catch NetworkError.decodingError {
                print ("Auth decoding error")
            } catch {
                print ("Auth unexpected error")
            }
        }
    }
    
    func resetUser(){
        user.phoneNumber = ""
        user.otpCode = ""
        user.otpGenerated = false
    }
}
