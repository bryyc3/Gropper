//
//  ContentView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TripsViewModel()
    @State var authenticated: Bool = AuthManager.shared.authStatus()
    
    var body: some View {
        Group{
            if(authenticated){
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
            }
            else{
                LoginView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .login)){_ in
            authenticated = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .logout)){_ in
            authenticated = false
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
