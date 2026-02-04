//
//  HostedTripView.swift
//  Gropper
//
//  Created by Bryce King on 12/18/25.
//

import SwiftUI

struct HostedTripView: View {
    @EnvironmentObject var model: TripsViewModel
    @State private var selectedRequestor: ContactInfo?
    @State private var removeRequestorConfirmation: Bool = false
    @State private var deleteTripConfirmation: Bool = false
    @Environment(\.dismiss) var dismiss
    let tripViewInfo: TripInfo?
    
    var body: some View {
        NavigationView {
            if let trip = tripViewInfo{
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
                                .popover(isPresented: Binding(
                                    get: { selectedRequestor?.phoneNumber == requestor.phoneNumber && removeRequestorConfirmation },
                                    set: { removeRequestorConfirmation = $0 }
                                )) {
                                    Button("Remove Requestor", role: .destructive) {
                                        if (trip.requestors.count > 1){
                                            Task{await model.removeRequestor(requestorInfo: requestor.phoneNumber, trip: trip.tripId!)}
                                            selectedRequestor = nil
                                            removeRequestorConfirmation.toggle()
                                        } else {
                                            print("cant remove")
                                        }
                                    }
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                                }
                            Button{
                                selectedRequestor = requestor
                                removeRequestorConfirmation.toggle()
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                            }
                            .offset(x: 160, y: -45)
                        }
                        
                    }
                    Button("Finish Trip") {
                        deleteTripConfirmation.toggle()
                    }
                    .popover(isPresented: Binding(
                        get: { deleteTripConfirmation },
                        set: { deleteTripConfirmation = $0 }
                    )) {
                        Button("Delete Trip", role: .destructive) {
                            Task{
                                let tripDeleted = await model.deleteTrip(trip: trip.tripId!)
                                if tripDeleted {
                                    dismiss()
                                }
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
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
            else{
                Text("Trip No Longer Exists")
            }
        }
    }
}
