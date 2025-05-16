//
//  RequestItems.swift
//  Gropper
//
//  Created by Bryce King on 5/6/25.
//

import Foundation

func requestItems(items: [ItemRequested]) async throws{
    let endpoint = "http://localhost:8080/request-items"
    guard let url = URL(string: endpoint) else{
        throw RequestItemsError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["items": items]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let (data,response) = try await URLSession.shared.data(for: request)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw RequestItemsError.invalidResponse
    }
    
}//submit request for items


enum RequestItemsError: Error{
    case invalidURL
    case invalidResponse
}
