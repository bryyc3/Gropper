//
//  PendingHostCard.swift
//  Gropper
//
//  Created by Bryce King on 11/13/25.
//

import SwiftUI

struct PendingHostCard: View {
    @EnvironmentObject var model: TripsViewModel
    @State private var showingDeclineConfirmation: Bool = false
    @State private var showingAcceptionConfirmation: Bool = false
    
    let trips: [TripInfo]
    let colorScheme: [Color]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack{
                ForEach(Array(trips.enumerated()), id: \.offset) {index, trip in
                    HStack {
                        if let contactPhoto = imageData(info: trip.host.contactPhoto){
                            Image(uiImage: contactPhoto)
                                .resizable()
                                .frame(width: 45, height: 45)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        }
                        VStack {
                            Text("Requestor:\n \(trip.host.contactName ?? trip.host.phoneNumber)")
                                .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                                .font(.system(size: 17, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Trip To \(trip.location)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(3)
                        
                        HStack{
                            Button {
                                Task{await model.acceptTrip(trip: trip.tripId!)}
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                            }
                            
                            Button {
                                showingDeclineConfirmation.toggle()
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                            }
                            .confirmationDialog("Are you sure you want to decline this request?", isPresented: $showingDeclineConfirmation) {
                                Button("Decline", role: .destructive){
                                    Task{await model.deleteTrip(trip: trip.tripId!)}
                                }
                            } message: {
                                Text("Are you sure you want to decline this request?")
                            }
                        }
                    }
                    .padding(10)
                }
                .frame(height: 120)
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Gradient(colors: colorScheme))
                    .shadow(radius: 7))
                .padding(10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    PendingHostCard(trips: [TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])],colorScheme: TripType.host.pendingColorScheme)
}
