//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var model: TripsViewModel
    @State private var logout = false
    @State private var logoutSuccess = true
    
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
                            Button(role: .destructive) {
                                Task {
                                    logoutSuccess = try await AuthManager.shared.logout()
                                }
                            } label: {
                                Text("Logout")
                            }
                        } message: {
                            Text("Are you sure you want to logout?")
                        }
                        if(!logoutSuccess){
                            Text("There was an error logging you out")
                                .foregroundColor(.red)
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
