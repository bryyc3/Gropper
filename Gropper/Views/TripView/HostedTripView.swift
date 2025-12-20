//
//  HostedTripView.swift
//  Gropper
//
//  Created by Bryce King on 12/18/25.
//

import SwiftUI

struct HostedTripView: View {
    @EnvironmentObject var model: TripsViewModel
    let tripIndex: Int
    
    var body: some View {
        NavigationView {
            if let trip = model.confirmedHostedTrips?[tripIndex]{
                VStack{
                    Text("Trip To \n \(trip.location)")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                    Text("Host: You")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                        .padding(.bottom, 7)
                    Text("Items Requested")
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    ScrollView(.vertical){
                        ForEach(trip.requestors, id: \.phoneNumber){requestor in
                            RequestorCard(requestor: requestor, preview: false)
                                .padding()
                        }
                    }
                    Button("Finish Trip") {
                        Task{
                            await model.deleteTrip(trip: trip.tripId!)
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .confirmationAction){
                            NavigationLink(destination: AddRequestorsForm(tripId: trip.tripId!, onFormSubmit: {Task{ await model.retrieveTrips()}})){
                                Text("Add Requestors")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(.horizontal, 65)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
}
