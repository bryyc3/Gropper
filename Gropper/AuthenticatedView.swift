//
//  AuthenticatedView.swift
//  Gropper
//
//  Created by Bryce King on 2/24/26.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var viewModel = TripsViewModel()
    
    var body: some View {
        TabView{
            DashboardView(model: viewModel)
                .tabItem{
                    Label("Dashboard", systemImage: "house")
                        .environment(\.symbolVariants, .none)
                }
            PendingTripsView(model: viewModel)
                .tabItem{
                    Label("Pending Trips", systemImage: "basket")
                        .environment(\.symbolVariants, .none)
                }
                .badge(viewModel.pendingHostedTrips?.count ?? 0)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    AuthenticatedView()
}
