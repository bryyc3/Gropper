//
//  RequestorTrips.swift
//  Gropper
//
//  Created by Bryce King on 9/9/25.
//

import SwiftUI

struct RequestorTrips: View {
    let trips: [TripInfo]
    let colorScheme: [Color]
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(Array(trips.enumerated()), id: \.offset) {index, trip in
                    VStack{
                        if let contactPhoto = imageData(info: trip.host.contactPhoto){
                            Image(uiImage: contactPhoto)
                                .resizable()
                                .frame(width: 35, height: 35)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .offset(y: -8)
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        }
                        VStack{
                            Text(trip.location)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                            Text("Host: \(trip.host.contactName ?? trip.host.phoneNumber)")
                                .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                                .fontWeight(.semibold)
                        }
                        
                        NavigationLink(destination: TripView(tripData: trip, preview: .request)){
                            Text("View Trip")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.horizontal, 55)
                                .padding(.vertical, 5)
                        }
                        .foregroundColor(.white)
                        .background(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        .cornerRadius(50)
                        .padding(.bottom, 15)
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1)))
                        .shadow(radius: 3))
                    
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(12, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 170)
        .padding(7)
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Gradient(colors: colorScheme))
            .shadow(radius: 7))
    }
}

#Preview {
    RequestorTrips(trips: [TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])],colorScheme: TripType.request.colorScheme)
}
