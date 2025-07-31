//
//  TripPreview.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct TripPreview: View {
    var tripData: TripInfo
    
    var body: some View {
        Text(/*trip.location*/ "Test Location")
        LazyHStack{
            RequestorCard(requestor: tripData.requestors[0])
        }
    }
}

#Preview {
    TripPreview(tripData: TripInfo())
}
