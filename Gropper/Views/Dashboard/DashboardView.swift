//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var model: TripsViewModel
    @State private var logout = false
    
    var body: some View {
        NavigationStack{
            VStack{
                CreateTripNav()
                ScrollView(.vertical){
                    VStack{
                        TripPreview(previewType: .host, tripData: model.confirmedHostedTrips)
                        TripPreview(previewType: .request, tripData: model.confirmedRequestedTrips)
                        
                        Button("Logout") {
                            logout.toggle()
                        }
                        .confirmationDialog("Are you sure you want to cancel this request?", isPresented: $logout) {
                            Button("Logout", role: .destructive) {
                                AuthManager.shared.logout()
                            }
                        } message: {
                            Text("Are you sure you want to logout?")
                        }
                    }
                }
                .scrollIndicators(ScrollIndicatorVisibility.never)
                .refreshable {
                    Task{
                        await model.retrieveTrips()
                    }
                }
            }
            .padding(7)
        }
    }
}
