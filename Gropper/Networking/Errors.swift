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
    case invalidResponse
    case decodingError
}
