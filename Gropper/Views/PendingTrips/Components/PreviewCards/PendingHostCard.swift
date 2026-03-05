//
//  PendingHostCard.swift
//  Gropper
//
//  Created by Bryce King on 11/13/25.
//

import SwiftUI

struct PendingHostCard: View {
    @EnvironmentObject var model: TripsViewModel
    @State private var selectedTrip: String?
    @State private var showingDeclineConfirmation: Bool = false
    @State private var acceptTrip: ApiResponse = ApiResponse(status200: true, message: nil)
    @State private var deleteTrip: ApiResponse = ApiResponse(status200: true, message: nil)
    
    let trips: [TripInfo]
    let colorScheme: [Color]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(trips.enumerated()), id: \.offset) {index, trip in
                    HStack {
                        if let contactPhoto = imageData(info: trip.requestors[0].contactPhoto) {
                            Image(uiImage: contactPhoto)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 45, height: 45)
                                .padding(.leading, 10)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                .padding(.leading, 10)
                        }
                        VStack {
                            Text("Requestor:\n \(trip.requestors[0].contactName ?? trip.requestors[0].phoneNumber)")
                                .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Trip to: \n\(trip.location)")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                            Text(trip.locationDescription)
                                .font(.system(size: 10, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        }
                        .padding(3)
                        
                        HStack{
                            Button {
                                Task{acceptTrip = try await model.acceptTrip(trip: trip.tripId!)}
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                            }
                            
                            Button {
                                selectedTrip = trip.tripId
                                showingDeclineConfirmation.toggle()
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                            }
                            
                        }
                        .padding(10)
                    }
                    .frame(width: 300, height: 120)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(Gradient(colors: colorScheme))
                        .shadow(radius: 7))
                    .padding(10)
                    if (acceptTrip.status200 == false) {
                        Text(acceptTrip.message ?? "Error Accepting Trip")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.red)
                            .padding()
                    }
                    if (deleteTrip.status200 == false) {
                        Text(deleteTrip.message ?? "Error Deleting Trip")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .scrollTargetLayout()
        }
        .confirmationDialog("Are you sure you want to decline this request?", isPresented: $showingDeclineConfirmation) {
            Button("Decline", role: .destructive){
                Task{deleteTrip = try await model.deleteTrip(trip: selectedTrip!)}
            }
        } message: {
            Text("Are you sure you want to decline this request?")
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    PendingHostCard(trips: [TripInfo(host: ContactInfo(phoneNumber: "testtttttttttt"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])],colorScheme: TripType.host.pendingColorScheme)
}
