//
//  StackedTripCards.swift
//  Gropper
//
//  Created by Bryce King on 8/29/25.
//

import SwiftUI

struct StackedTripCards: View {
    @State private var dragOffset: CGSize = .zero
    @State private var topCardIndex: Int = 0
    var height: CGFloat = 10
    let trips: [TripInfo]
    let colorScheme: [Color]
    
    var body: some View {
        ZStack{
            ForEach(Array(trips.enumerated()), id: \.offset){index, trip in
                let visualIndex = (index - topCardIndex + trips.count) % trips.count
                let progress = min(abs(dragOffset.height) / 150, 1)
                let signedProgress = (dragOffset.height >= 0 ? 1 : -1) * progress
                
                VStack(spacing: 0){
                    VStack(alignment: .leading) {
                        NavigationLink(destination: TripView(tripIndex: index, preview: .host)){
                            Text(trip.location)
                                .font(.system(size: 20, weight: .bold))
                                .frame(alignment: .leading)
                                .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                        }
                        .padding(.top, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(trip.requestors, id: \.self.phoneNumber){user in
                                LazyHStack{RequestorCard(requestor: user, preview: true)}
                            }
                        }
                        .offset(y: -2)
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(7)
                    .frame(height: 140)
                }
                .background(RoundedRectangle(cornerRadius: 25)
                                .fill(Gradient(colors: colorScheme))
                                .shadow(radius: visualIndex == 0 ? 7 : CGFloat(visualIndex) * 3))
                .frame(height: 170)
                .offset(x: visualIndex == 0 ? 0 : CGFloat(visualIndex) * 3, y: visualIndex == 0 ? dragOffset.height : CGFloat(visualIndex) * 12)
                .scaleEffect(1 - CGFloat(visualIndex) * 0.05)
                .zIndex(Double(trips.count - visualIndex))
                .rotation3DEffect(
                    .degrees(
                        (visualIndex == 0 || visualIndex == 1) ? -10 * signedProgress : 0),
                    axis: (1, 0, 0)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let minY: CGFloat = -60
                            let maxY: CGFloat = 10
                            
                            let newY = value.translation.height
                            dragOffset.height = min(max(newY, minY), maxY)
                        }
                        .onEnded{ value in
                            let threshold: CGFloat = -20
                            let direction: CGFloat = (value.translation.height >= 0 ? 1 : -1)
                            let delay = direction < 0 ? 0.18 : 0.20
                            
                            if (value.translation.height) < threshold {
                                let direction: CGFloat = value.translation.height > 0 ? 1 : -1
                                
                                withAnimation(.smooth(duration:0.2)){
                                    dragOffset.height = direction < 0 ? -height : height * 1.33
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                    withAnimation(.smooth(duration:0.5)){
                                        topCardIndex = (topCardIndex + 1) % trips.count
                                        dragOffset = .zero
                                    }
                                }
                            } else {
                                withAnimation{
                                    dragOffset = .zero
                                }
                            }
                            
                        }
                )
            }
        }
        .padding(.top, 7)
        .padding(.bottom, 15)
    }
}

#Preview {
    StackedTripCards(trips: [TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])],colorScheme: TripType.host.colorScheme)
}
