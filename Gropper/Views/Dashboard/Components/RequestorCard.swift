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
        HStack{
            if let imageData = requestor.contactPhoto, let contactPhoto = UIImage(data: imageData){
                Image(uiImage: contactPhoto)
            } else {
                Text("No image")
            }
            
            if let contactName = requestor.contactName{
                Text(contactName)
            } else {
                Text(requestor.phoneNumber)
            }
        }
        HStack {
            if(requestor.itemsRequested.count > 0){
                List(requestor.itemsRequested){ item in
                    Text(item.itemName)
                }
            }
        }
        .onAppear {
            Task{
                requestor = await model.retrieveContact(user: requestor)
            }
        }
    }
}

#Preview {
    //RequestorCard()
}
