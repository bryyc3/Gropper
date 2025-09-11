//
//  TripPreview.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct TripPreview: View {
    let previewType: TripType
    let tripData: [TripInfo]?
    
    var body: some View {
        VStack{
            Text(previewType.tripPreviewTitle)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
            
            if let tripArray = tripData{
                if previewType == .host{
                    StackedTripCards(trips: tripArray, colorScheme: previewType.colorScheme)
                }
                
                if previewType == .request{
                    RequestorTrips(trips: tripArray, colorScheme: previewType.colorScheme)
                }
            }  else {
                VStack{
                    Text("Nothing Here Yet!")
                        .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                }
                
            }
        }
    }
}

#Preview {
    TripPreview(previewType: .request, tripData: [
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]),
        
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]),
        
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "6", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]),
        
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]),
        
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]),
        
        TripInfo(host: ContactInfo(phoneNumber: "test"), location: "Test Location", requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "6", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])])
    ]
    )
}
