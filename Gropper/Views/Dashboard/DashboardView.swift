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
            HStack{
                NavigationLink("Feeling Generous?"){
                    HostTripView()
                }
                NavigationLink("Need Something?"){
                    RequestTripView()
                }
                Button("Get Trips"){
                    viewModel.retrieveTrips()
                }
            }
        }
    }
}


#Preview {
    DashboardView()
}
