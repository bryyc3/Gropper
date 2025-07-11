//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @EnvironmentObject var authVm: AuthenticationViewModel
    
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
            Button("Logout"){
                Task{
                    viewModel.removeTokens()
                    if(try getToken(forKey: "refreshToken") == nil && getToken(forKey: "accessToken") == nil){
                        authVm.authenticated.toggle()
                    }
                    
                }
            }
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
            if(!viewModel.loggedIn){
                authVm.authenticated.toggle()
            }
            viewModel.retrieveTrips()
        }
    }
}


//#Preview {
    //DashboardView()
//}
