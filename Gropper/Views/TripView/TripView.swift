//
//  TripView.swift
//  Gropper
//
//  Created by Bryce King on 8/15/25.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var model: DashboardViewModel
    let tripData: TripInfo
    let preview: TripType
    
    var body: some View {
        Text("Trip To \(tripData.location)")
        if preview == .host {
            Text("Hosted By: You")
            Text("Items Requested")
            ScrollView(.vertical){
                ForEach(tripData.requestors, id: \.phoneNumber){requestor in
                    RequestorCard(requestor: requestor, preview: false)
                }
            }
        }
        
        else {
            Text("Hosted By: \(tripData.host)")
            Text("Items You Requested")
            
            if let user = tripData.requestors.first(where: {$0.phoneNumber == /*model.userNumber*/ "5"}){
                ScrollView(.vertical){
                    HStack{
                        if let items = user.itemsRequested{
                            ForEach(items, id: \.id){item in
                                Text(item.itemName)
                                    .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                    .padding(10)
                                    .background(
                                        Capsule()
                                            .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                                    )
                            }
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TripView(tripData: TripInfo(host: ContactInfo(phoneNumber: "test"), requestors: [ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")]), ContactInfo(phoneNumber: "5", itemsRequested: [ItemInfo(id: UUID(),itemName: "a", itemDescription: "a")])]), preview: .request)
}
