//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var model: TripsViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                CreateTripNav()
                ScrollView(.vertical){
                    VStack{
                        TripPreview(previewType: .host, tripData: model.confirmedHostedTrips)
                        TripPreview(previewType: .request, tripData: model.confirmedRequestedTrips)
                        Button("Logout"){
                            AuthManager.shared.logout()
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
