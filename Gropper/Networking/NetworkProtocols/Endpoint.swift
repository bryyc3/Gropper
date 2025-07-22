//
//  Endpoint.swift
//  Gropper
//
//  Created by Bryce King on 7/8/25.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Encodable]? { get }
}

extension Endpoint {
    func urlRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        
        if var requestBody = body {
            for (key, value) in requestBody {
                let data = try JSONEncoder().encode(value)
                guard let dataString = String(data: data, encoding: .utf8) else {
                    throw BuildRequestError.encodingError
                }
                requestBody[key] = dataString
            }//encode each dictionary value and re-pair it with key
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
        }
        return request
    }
}//build full request in URLRequest format
