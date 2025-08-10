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
            Image(uiImage: imageData(info: requestor.contactPhoto))

            Text(requestor.contactName ?? requestor.phoneNumber)
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

func imageData(info: Data?) -> UIImage{
    if let imageData = info, let contactPhoto = UIImage(data: imageData){
        return contactPhoto
    } else {
        return UIImage(systemName: "person.circle")!
    }
}

#Preview {
    //RequestorCard()
}
