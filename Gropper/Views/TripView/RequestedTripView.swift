//
//  RequestedTripView.swift
//  Gropper
//
//  Created by Bryce King on 12/18/25.
//

import SwiftUI

struct RequestedTripView: View {
    @EnvironmentObject var model: TripsViewModel
    @State private var selectedItem: ItemInfo?
    @State private var itemPopover = false
    let trip: TripInfo
    let columns = [GridItem(.flexible(minimum: 0, maximum: 20))]
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Trip To \n \(trip.location)")
                    .font(.system(size: 40, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                Text("Host: \(trip.host.contactName ?? trip.host.phoneNumber)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                VStack{
                    Text("Items You Requested")
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    
                    
                    ScrollView(.vertical){
                        FlowLayout(spacing: 10){
                            if let user = trip.requestors.first(where: {$0.phoneNumber == model.userNumber}){
                                if let items = user.itemsRequested {
                                    ForEach(items, id: \.id){item in
                                        Button(item.itemName) {
                                            selectedItem = item
                                            itemPopover = true
                                        }
                                            .font(.system(size: 25))
                                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                            .padding(10)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .frame(minWidth: 0, maxWidth: 170)
                                            .background(
                                                Capsule()
                                                    .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                                            )
                                            .popover(isPresented: Binding(
                                                            get: { selectedItem?.id == item.id && itemPopover },
                                                            set: { itemPopover = $0 }
                                            )) {
                                                VStack(spacing: 12) {
                                                    Text(item.itemName)
                                                        .fontWeight(.semibold)
                                                    
                                                    Text(item.itemDescription)
                                                        .padding(.bottom, 8)
                                                    
                                                    Button("Delete Item") {Task{await model.deleteItem(trip: trip.tripId!, itemName: item.itemName)}}
                                                    
                                                    Button("Close") { itemPopover = false }
                                                }
                                                .padding()
                                                .presentationCompactAdaptation(.popover)
                                            }
                                    }
                                }
                            }
                            NavigationLink(destination: AddItemsForm(tripId: trip.tripId!, host: trip.host.phoneNumber, onFormSubmit: {Task{ await model.retrieveTrips()}})){
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(#colorLiteral(red: 0.5086488128, green: 0.3238898516, blue: 0.8902593255, alpha: 1)))
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
}
