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
                    .padding(7)
                PendingPreview(previewType: .request, tripData: viewModel.pendingRequestedTrips)
                    .padding(7)
            }
        }
        .padding(.top, 50)
        .scrollIndicators(ScrollIndicatorVisibility.never)
        .defaultScrollAnchor(.center, for: .alignment)
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
