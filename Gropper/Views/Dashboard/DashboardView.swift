//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = TripsViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                CreateTripNav()
                ScrollView(.vertical){
                    VStack{
                        TripPreview(previewType: .host, tripData: viewModel.confirmedHostedTrips)
                        TripPreview(previewType: .request, tripData: viewModel.confirmedRequestedTrips)
                        Button("Logout"){
                            AuthManager.shared.logout()
                        }
                    }
                }
                .scrollIndicators(ScrollIndicatorVisibility.never)
                .refreshable {
                    Task{
                        await viewModel.retrieveTrips()
                    }
                }
            }
            .padding(7)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    DashboardView()
}
