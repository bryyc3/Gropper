//
//  VerifyRefreshToken.swift
//  Gropper
//
//  Created by Bryce King on 6/11/25.
//

import Foundation


func verifyRefreshToken() async -> Bool{
    
    //get refresh token from keychain
    //send refresh token to api
    //if no refresh token is found in keychain return false
    //if refresh was invalid delete the refresh from keychain and return false
    //if refresh is valid replace current access token with new one and return true
    
    return false
}


enum VerifyRefreshError: Error {
    case invalidURL
    case invalidResponse
}
