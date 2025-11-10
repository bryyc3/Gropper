//
//  RequestorCard.swift
//  Gropper
//
//  Created by Bryce King on 7/23/25.
//

import SwiftUI

struct RequestorCard: View {
    let requestor: ContactInfo
    let preview: Bool
    
    var body: some View {
        VStack{
            ZStack{
                if let contactPhoto = imageData(info: requestor.contactPhoto){
                    Image(uiImage: contactPhoto)
                        .resizable()
                        .position(x: -85, y: -2)
                        .frame(width: 35, height: 35)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .position(x: -85, y: -2)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                }
                
                Text(requestor.contactName ?? requestor.phoneNumber)
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(width: 200)
            
            VStack{
                if let items = requestor.itemsRequested{
                    HStack {
                        ForEach(items.prefix(2)) { item in
                            if item.itemName == " "{
                                Text("No Items Requested")
                                    .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                            } else {
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
                        }
                        if items.count > 2 {
                            Text("+\(items.count - 2)")
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("No Items Requested")
                        .foregroundColor(.gray)
                }
                
            }
            .frame(width: 200, height: 35)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1)))
            .shadow(radius: 3))
    }
}

#Preview {
    RequestorCard(requestor: ContactInfo(phoneNumber: "5089017225", itemsRequested: [ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item"), ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item"),ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item")]), preview: true)
}
