//
//  PendingTripsView.swift
//  Gropper
//
//  Created by Bryce King on 11/11/25.
//

import SwiftUI

struct PendingTripsView: View {
    @StateObject var model: TripsViewModel
    @State private var getTrips: ApiResponse = ApiResponse(status200: true, message: nil)
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                PendingPreview(previewType: .host, tripData: model.pendingHostedTrips)
                    .padding(7)
                PendingPreview(previewType: .request, tripData: model.pendingRequestedTrips)
                    .padding(7)
                if (getTrips.status200 == false) {
                    Text(getTrips.message ?? "Error Getting Trips Youre Apart Of")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding(.top, 50)
        .scrollIndicators(ScrollIndicatorVisibility.never)
        .defaultScrollAnchor(.center, for: .alignment)
        .refreshable {
            Task{
                getTrips = try await model.retrieveTrips()
            }
        }
    }
}
