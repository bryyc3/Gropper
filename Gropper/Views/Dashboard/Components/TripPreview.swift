//
//  TripPreview.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct TripPreview: View {
    let tripType: tripType
    var tripData: TripInfo?
    
    var body: some View {
        VStack{
            if let trip = tripData {
                Text(tripType.rawValue)
                Text(/*trip.location*/ "Test Location")
                //requestor card
            } else {
                Text("No Trips Found")
            }
           
        }
    }
}

enum tripType: String{
    case hosted = "Hosted Trips"
    case requested = "Requested Trips"
}

#Preview {
    TripPreview(tripType: .hosted, tripData: TripInfo())
}
