//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                CreateTripNav()
                ScrollView(.vertical){
                    VStack{
                        TripPreview(previewType: .host, tripData: viewModel.hostedTrips)
                            .padding(7)
                        TripPreview(previewType: .request, tripData: viewModel.requestedTrips)
                            .padding(7)
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
            .padding()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    DashboardView()
}
