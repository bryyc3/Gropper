//
//  RequestorCard.swift
//  Gropper
//
//  Created by Bryce King on 7/23/25.
//

import SwiftUI

struct RequestorCard: View {
    @EnvironmentObject var model: DashboardViewModel
    @State var requestor: RequestorInfo
    
    var body: some View {
        VStack{
            HStack{
                Image(uiImage: imageData(info: requestor.contactPhoto))
                    .position(x: -10, y: 5)
                    .frame(width: 50, height: 50)

                Text(requestor.contactName ?? requestor.phoneNumber)
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
            }
            HStack {
                if(requestor.itemsRequested.count > 0){
                    ForEach(requestor.itemsRequested){ item in
                        HStack{
                            Text(item.itemName)
                                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)))
                                .frame(width: 20, height: 20)
                        }
                        .padding(10)
                        .background(
                            Capsule()
                                .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                        )
                        
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color(#colorLiteral(red: 0.9495772719, green: 0.9495772719, blue: 0.9495772719, alpha: 1))))
        .onAppear {
            Task{
                //requestor = await model.retrieveContact(user: requestor)
            }
        }
    }
}

#Preview {
    RequestorCard(requestor: RequestorInfo(phoneNumber: "5089017225", itemsRequested: [ItemInfo(id: UUID(),itemName: "test item", itemDescription: "test item")]))
}
