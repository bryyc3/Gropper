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
                    HostTripView(onFormSubmit: {
                        viewModel.retrieveTrips()})
                }
                NavigationLink("Need Something?"){
                    RequestTripView(onFormSubmit: {
                        viewModel.retrieveTrips()})
                }
            }
            
        }
        VStack{
            Text("Trips Youre Hosting")
            ZStack{
                if let hostedTrips = viewModel.hostedTrips{
                    List(hostedTrips, id: \.self.tripId){ trip in
                        TripPreview(tripData: trip)
                    }
                }
                
            }
            
            Text("Trips Youre Apart Of")
            ZStack{
                if let requestedTrips = viewModel.requestedTrips{
                    List(requestedTrips, id: \.self.tripId){ trip in
                        TripPreview(tripData: trip)
                    }
                }
                
            }
        }
        .environmentObject(viewModel)
        .onAppear{
            viewModel.retrieveTrips()
        }
    }
}

#Preview {
    DashboardView()
}
