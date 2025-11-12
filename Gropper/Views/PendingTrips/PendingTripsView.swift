//
//  PendingTripsView.swift
//  Gropper
//
//  Created by Bryce King on 11/11/25.
//

import SwiftUI

struct PendingTripsView: View {
    @StateObject var viewModel = TripsViewModel()
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                PendingPreview(previewType: .host, tripData: viewModel.pendingHostedTrips)
                PendingPreview(previewType: .request, tripData: viewModel.pendingRequestedTrips)
            }
        }
        .scrollIndicators(ScrollIndicatorVisibility.never)
        .refreshable {
            Task{
                await viewModel.retrieveTrips()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    PendingTripsView()
}
