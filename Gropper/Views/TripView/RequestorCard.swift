//
//  RequestorCard.swift
//  Gropper
//
//  Created by Bryce King on 7/23/25.
//

import SwiftUI

struct RequestorCard: View {
    @State private var selectedItem: ItemInfo?
    @State private var itemPopover = false
    let requestor: ContactInfo
    let preview: Bool
    
    var body: some View {
        VStack{
            ZStack{
                if let contactPhoto = imageData(info: requestor.contactPhoto){
                    if preview{
                        Image(uiImage: contactPhoto)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .position(x: -85, y: -2)
                            .frame(width: 35, height: 35)
                    } else {
                        Image(uiImage: contactPhoto)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .position(x: -125)
                            .frame(width: 55, height: 55)
                    }
                } else {
                    if preview{
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .position(x: -85, y: -2)
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .position(x: -125)
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    }
                }
                
                if preview{
                    Text(requestor.contactName ?? requestor.phoneNumber)
                        .font(.headline)
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        .lineLimit(1)
                        .truncationMode(.tail)
                } else {
                    Text(requestor.contactName ?? requestor.phoneNumber)
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .frame(width: 200)
            
            if preview {
                VStack{
                    if let items = requestor.itemsRequested{
                        HStack {
                            ForEach(items.prefix(2)) { item in
                                Text(item.itemName)
                                    .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                                    .font(.system(size: 15))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .padding(7)
                                    .background(
                                        Capsule()
                                            .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                                    )
                                
                            }
                            if items.count > 2 {
                                Text("+\(items.count - 2)")
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Text("No Items Requested")
                            .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 200, height: 35)
            } else {
                VStack{
                    if let items = requestor.itemsRequested{
                        ScrollView(.vertical) {
                            FlowLayout(spacing: 10){
                                ForEach(items){ item in
                                    Button {
                                        selectedItem = item
                                        itemPopover = true
                                    } label: {
                                        Text(item.itemName)
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
                                                
                                                Button("Close") { itemPopover = false }
                                            }
                                            .padding()
                                            .presentationCompactAdaptation(.popover)
                                        }
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 95)
                        
                    } else {
                        Text("No Items Requested")
                            .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                            .font(.system(size: 23))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(width: 300, height: 55)
                .padding(5)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1)))
            .shadow(radius: 3))
    }
}

#Preview {
    RequestorCard(requestor: ContactInfo(phoneNumber: "5089017225", itemsRequested: [ItemInfo(id: UUID(),itemName: " ", itemDescription: "test item"), ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item"),ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item"), ItemInfo(id: UUID(),itemName: "test itemsfdfsd", itemDescription: "test item")]), preview: false)
}
