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
                
                
                VStack{
                    Text(trip.location)
                        .foregroundStyle(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                        .fontWeight(.semibold)
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(trip.requestors, id: \.self.phoneNumber){user in
                                LazyHStack{RequestorCard(requestor: user)}
                            }
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Gradient(colors: colorScheme)))
                .frame(height: 200)
                .offset(x: visualIndex == 0 ? 0 : Double(visualIndex) * 2, y: visualIndex == 0 ? dragOffset.height : Double(visualIndex) * 7)
                .opacity(visualIndex == 0 ? 1.0 : Double(visualIndex + 1) / Double(trips.count))
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
        .padding()
    }
}
