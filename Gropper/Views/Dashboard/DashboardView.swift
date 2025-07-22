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
            if let hostedTrips = viewModel.trips.hostedTripData{
                ForEach(hostedTrips, id: \.tripId){
                    hostedTrip in Text(hostedTrip.location)
                }
            }
            else{
                Text("No hosted trips")
            }
        }
        .onAppear{
            viewModel.retrieveTrips()
        }
    }
}

#Preview {
    DashboardView()
}
