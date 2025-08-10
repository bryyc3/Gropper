//
//  TripPreview.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct TripPreview: View {
    @EnvironmentObject var model: DashboardViewModel
    let previewType: TripType
    
    var body: some View {
        Text(previewType.tripPreviewTitle)
        ZStack{
            Text(/*trip.location*/ "Test Location")
            if previewType == .host{
                if let hostedTrips = model.hostedTrips{
                    List(hostedTrips, id: \.self.tripId){trip in
                        LazyHStack{RequestorCard(requestor: trip.requestors[0])}
                    }
                }
            }
        }
    }
}

#Preview {
    //TripPreview(tripData: TripInfo())
}
