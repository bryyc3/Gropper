//
//  Errors.swift
//  Gropper
//
//  Created by Bryce King on 7/8/25.
//

import Foundation

enum BuildRequestError: Error{
    case encodingError
}

enum NetworkError: Error{
    case invalidURL
    case noResponse
    case invalidResponse
    case decodingError
    case unauthorized
    case noAccessToken
}
