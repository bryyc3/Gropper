//
//  GetItemsRequested.swift
//  Gropper
//
//  Created by Bryce King on 5/15/25.
//

import Foundation

func getItems() async throws -> [ItemInfo]{
    let endpoint = "http://localhost:8080/item-requests"
    guard let url = URL(string: endpoint) else{
        throw ItemsRequestedError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
        throw ItemsRequestedError.invalidResponse
    }
    
    do{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let items: [ItemInfo] =  try decoder.decode([ItemInfo].self, from: data)
        return items
    } catch {
        throw ItemsRequestedError.decodingError
    }
}//get all items requested within an trip


enum ItemsRequestedError: Error{
    case invalidURL
    case invalidResponse
    case decodingError
}
