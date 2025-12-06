//
//  PendingRequestCard.swift
//  Gropper
//
//  Created by Bryce King on 11/13/25.
//

import SwiftUI

struct PendingRequestCard: View {
    @EnvironmentObject var model: TripsViewModel
    @State private var selectedTrip: String?
    @State private var showingCancelConfirmation: Bool = false
    
    let trips: [TripInfo]
    let colorScheme: [Color]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(trips.enumerated()), id: \.offset) {index, trip in
                    ZStack {
                        VStack {
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
                            Text("Host:\n\(trip.host.contactName ?? trip.host.phoneNumber)")
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .multilineTextAlignment(.center)
                                .font(.system(size: 15, weight: .bold))
                            VStack{
                                Text("Trip To \(trip.location)")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                    .padding(.top, 10)
                                VStack{
                                    Text("Items")
                                        .font(.system(size: 17, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                        .padding(5)
                                    if let user = trip.requestors.first(where: {$0.phoneNumber == "5"}){
                                        ScrollView(.vertical) {
                                            if let items = user.itemsRequested{
                                                FlowLayout(spacing: 10){
                                                    ForEach(items, id: \.id){item in
                                                        Text(item.itemName)
                                                            .font(.system(size: 15))
                                                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                                            .padding(5)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                            .frame(minWidth: 0, maxWidth: 90)
                                                            .background(
                                                                Capsule()
                                                                    .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                        .frame(minWidth: 0, maxHeight: 65)
                                    }
                                }
                                .frame(width: 200, height: 85)
                                .padding(5)
                                Button("Nevermind") {
                                    selectedTrip = trip.tripId
                                    showingCancelConfirmation.toggle()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Gradient(colors: [Color(#colorLiteral(red: 0.9183334112, green: 0.374332577, blue: 0.4192636609, alpha: 1)), Color(#colorLiteral(red: 0.925404489, green: 0.2444823682, blue: 0.2255580425, alpha: 1))]))
                                .foregroundColor(.white)
                                .buttonBorderShape(.capsule)
                                .padding()
                            }
                            .background(RoundedRectangle(cornerRadius: 25)
                                .fill(Gradient(colors: [Color(#colorLiteral(red: 0.9322556853, green: 0.9322556853, blue: 0.9322556853, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]))
                                .shadow(radius: 7))
                            
                        }
                        .confirmationDialog("Are you sure you want to cancel this request?", isPresented: $showingCancelConfirmation) {
                            Button("Delete request", role: .destructive) {
                                Task{await model.deleteTrip(trip: selectedTrip!)}
                            }
                        } message: {
                            Text("Are you sure you want to cancel this request?")
                        }
                        .background(RoundedRectangle(cornerRadius: 25)
                            .fill(Gradient(colors: colorScheme))
                            .shadow(radius: 7))
                        .padding()
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(12, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    PendingRequestCard(trips: [TripInfo(host: ContactInfo(phoneNumber: "tes"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "aaaaaaaaaaaaa", itemDescription: "a"),ItemInfo(id: UUID(),itemName: "aaaaaa", itemDescription: "a"),ItemInfo(id: UUID(),itemName: "aaaaaa", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), TripInfo(host: ContactInfo(phoneNumber: "tes"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])],colorScheme: TripType.request.pendingColorScheme)
}
