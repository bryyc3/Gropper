//
//  Authentication.swift
//  Gropper
//
//  Created by Bryce King on 7/8/25.
//

import Foundation

struct Authentication: Endpoint {
    var baseUrl: URL
    var path: String
    var method: HttpMethod
    var headers: [String : String]?
    var body: [String : Encodable]?
    
    static func sendOtp(mobileNumber: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "simulate-otp",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["phoneNumber": mobileNumber]
        )
    }
    
    static func verifyOtp(mobileNumber: String, otp: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "simulate-otp-verification",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["phoneNumber": mobileNumber,
                   "userCode": otp]
        )
    }
    
    static func verifyRefreshToken(token: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://inoperable-guillermo-unconcentrically.ngrok-free.dev/")!,
            path: "verify-refresh",
            method: .post,
            headers: ["Authorization": token]
        )
    }
}
