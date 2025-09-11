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
            }
            .frame(width: 200)
            HStack {
                if let items = requestor.itemsRequested{
                    ForEach(items){ item in
                        Text(item.itemName)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                            .padding(10)
                            .background(
                                Capsule()
                                    .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                            )
                        
                    }
                } else {
                    Text("No Items Requested")
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1))))
    }
}

#Preview {
    RequestorCard(requestor: ContactInfo(phoneNumber: "5089017225", itemsRequested: [ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item")]), preview: true)
}
