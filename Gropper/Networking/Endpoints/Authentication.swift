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
            baseUrl: URL(string: "https://gropper-api-production.up.railway.app/")!,
            path: "generate-otp",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["phoneNumber": mobileNumber]
        )
    }
    
    static func verifyOtp(mobileNumber: String, otp: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://gropper-api-production.up.railway.app/")!,
            path: "verify-otp",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["phoneNumber": mobileNumber,
                   "userCode": otp]
        )
    }
    
    static func verifyRefreshToken(token: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://gropper-api-production.up.railway.app/")!,
            path: "verify-refresh",
            method: .post,
            headers: ["Authorization": token]
        )
    }
    
    static func allowNotifications(phoneNumber: String, token: String) -> Authentication {
        return Authentication(
            baseUrl: URL(string: "https://gropper-api-production.up.railway.app/")!,
            path: "allow-notifications",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: ["userNumber": phoneNumber,
                   "userToken": token]
        )
    }
}
