//
//  TripType.swift
//  Gropper
//
//  Created by Bryce King on 9/10/25.
//

import Foundation
import SwiftUI

enum TripType {
    case host
    case request
    
    var createTripButtonTitle: String {
        switch self {
            case .host:
                return "Create Trip"
            case .request:
                return "Request Trip"
        }
    }
    
    var createTripImage: String {
        switch self {
            case .host:
                return "host_trip_img"
            case .request:
                return "request_trip_img"
        }
    }
    
    var createTripTitle: String {
        switch self {
        case .host:
            return "Heading out and willing to pick up items"
        case .request:
            return "Request someone to pick up items for you"
        }
    }
    
    var createTripSubtitle: String {
        switch self {
        case .host:
            return "Let others know where youre going and that you can pick up items they need"
        case .request:
            return "Request for someone to pick up items you need from a specified location."
        }
    }
    
    var dashPreviewTitle: String {
        switch self {
            case .host:
                return "Trips You're Hosting"
            case .request:
                return "Trips You're Apart Of"
        }
    }
    
    var dashColorScheme: [Color] {
        switch self {
            case .host:
            return [Color(#colorLiteral(red: 0.8416427374, green: 0.8715619445, blue: 0.9481450915, alpha: 1)),Color(#colorLiteral(red: 0.5456431508, green: 0.6622825265, blue: 0.8428704143, alpha: 1))]
        case .request:
            return [Color(#colorLiteral(red: 0.8366934657, green: 0.7335241437, blue: 0.8978629708, alpha: 1)),Color(#colorLiteral(red: 0.6828602552, green: 0.4983463287, blue: 0.9405499697, alpha: 1))]
        }
    }
    
    var pendingTripTitle: String {
        switch self {
        case .host:
            return "Trips Pending Your Approval"
        case .request:
            return "Pending Requested Trips"
        }
    }
    
    var pendingColorScheme: [Color] {
        switch self {
            case .host:
            return [Color(#colorLiteral(red: 0.9608463645, green: 0.8262520432, blue: 0.5865539312, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
        case .request:
            return [Color(#colorLiteral(red: 0.8366934657, green: 0.7335241437, blue: 0.8978629708, alpha: 1)),Color(#colorLiteral(red: 0.6828602552, green: 0.4983463287, blue: 0.9405499697, alpha: 1))]
        }
    }
}
