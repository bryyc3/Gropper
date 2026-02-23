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
    
    func requestOtp() async {
        do{
            guard let userPhoneNumber = try? NumberParse(number: user.phoneNumber) else {
                throw NumberParseError.parseErr
            }
            let request = Authentication.sendOtp(mobileNumber: userPhoneNumber)
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
    
    func checkOtp() async throws -> Bool {
        do{
            guard let userPhoneNumber = try? NumberParse(number: user.phoneNumber) else {
                throw NumberParseError.parseErr
            }
            
            let request = Authentication.verifyOtp(mobileNumber: userPhoneNumber, otp: user.otpCode)
            guard let tokens = try await NetworkManager.shared.execute(endpoint: request, auth: false, type: WebTokens.self) else {
                return false
            }
            guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else {
                return false
            }
            AuthManager.shared.login(accessToken: accessToken, refreshToken: refreshToken, phoneNumber: userPhoneNumber)
            
            if let notificationToken = getItem(forKey: "notificationToken") {
                print(notificationToken)
                let request = Authentication.allowNotifications(phoneNumber: userPhoneNumber, token: notificationToken)
                try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self)
            }
            resetUser()
        } catch NumberParseError.parseErr {
            print("Number Parse Error")
        }
        catch BuildRequestError.encodingError {
            print("Login encoding error")
        } catch NetworkError.invalidURL {
            print ("Login invalid URL")
        } catch NetworkError.invalidResponse {
            print ("Login invalid response")
        } catch NetworkError.decodingError {
            print ("Login decoding error")
        } catch {
            print ("Login unexpected error")
        }
        return true
    }
    
    func resetUser(){
        user.phoneNumber = ""
        user.otpCode = ""
        user.otpGenerated = true
    }
}
