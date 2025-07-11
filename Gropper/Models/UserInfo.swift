//
//  UserInfo.swift
//  Gropper
//
//  Created by Bryce King on 7/9/25.
//


struct UserInfo {
    var phoneNumber: String?
    var otpCode: String?
    var authenticated = false
    var tokens = WebTokens()
}
