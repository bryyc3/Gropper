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
    
    func requestOtp() async throws -> ApiResponse {
        do{
            guard let userPhoneNumber = try? NumberParse(number: user.phoneNumber) else {
                return ApiResponse(status200: false, message: "Couldnt create network request (phone number parse error")
            }
            let request = Authentication.sendOtp(mobileNumber: userPhoneNumber)
            user.otpGenerated = try await NetworkManager.shared.execute(endpoint: request, auth: false, type: Bool.self) ?? false
        } catch BuildRequestError.encodingError{
            return ApiResponse(status200: false, message: "Couldnt generate OTP - Request Build Error")
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "Couldnt generate OTP - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "Couldnt generate OTP - Please Check Phone Number is Valid")
        } catch {
            return ApiResponse(status200: false, message: "Couldnt generate OTP - Unexpected Error, Try Again")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func checkOtp() async throws -> ApiResponse {
        do{
            guard let userPhoneNumber = try? NumberParse(number: user.phoneNumber) else {
                throw NumberParseError.parseErr
            }
            
            let request = Authentication.verifyOtp(mobileNumber: userPhoneNumber, otp: user.otpCode)
            guard let tokens = try await NetworkManager.shared.execute(endpoint: request, auth: false, type: WebTokens.self) else {
                return ApiResponse(status200: false, message: "Invalid Network Response")
            }
            guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else {
                return ApiResponse(status200: false, message: "Invalid Network Response")
            }
            AuthManager.shared.login(accessToken: accessToken, refreshToken: refreshToken, phoneNumber: userPhoneNumber)
            
            if let notificationToken = getItem(forKey: "notificationToken") {
                let request = Authentication.allowNotifications(phoneNumber: userPhoneNumber, token: notificationToken)
                try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self)
            }
            resetUser()
        } catch NumberParseError.parseErr {
            return ApiResponse(status200: false, message: "OTP Check Error - Couldnt parse Phone Number, Try Again")
        }
        catch BuildRequestError.encodingError {
            return ApiResponse(status200: false, message: "OTP Check Error - Request Build Error")
        } catch NetworkError.invalidURL {
            return ApiResponse(status200: false, message: "OTP Check Error - Network Endpoint Error")
        } catch NetworkError.invalidResponse {
            return ApiResponse(status200: false, message: "OTP Check Error - Incorrect/Expired OTP")
        } catch NetworkError.decodingError {
            return ApiResponse(status200: false, message: "OTP Check Error - Enter phone number and try again")
        } catch {
            return ApiResponse(status200: false, message: "OTP Check Error - Unexpected error, Try Again")
        }
        return ApiResponse(status200: true, message: nil)
    }
    
    func resetUser(){
        user.phoneNumber = ""
        user.otpCode = ""
        user.otpGenerated = true
    }
}
