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
                        VStack{
                            Text(trip.location)
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                            Text("Host: \(trip.host.contactName ?? trip.host.phoneNumber)")
                                .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 10)
                        NavigationLink(destination: TripView(tripData: trip, preview: .request)){
                            Text("View Trip")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 65)
                                .padding(.vertical, 5)
                        }
                        .foregroundColor(.white)
                        .background(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        .cornerRadius(50)
                        .padding()
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1))))
                    
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(20, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 170)
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Gradient(colors: colorScheme)))
    }
}

//#Preview {
//    RequestorTrips()
//}
