//
//  PendingPreview.swift
//  Gropper
//
//  Created by Bryce King on 11/12/25.
//

import SwiftUI

struct PendingPreview: View {
    let previewType: TripType
    let tripData: [TripInfo]?
    
    var body: some View {
        VStack{
            Text(previewType.pendingTripTitle)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            if let tripArray = tripData {
                if tripArray.isEmpty {
                    VStack {
                        Text("Nothing Here Yet!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 100)
                } else {
                    if previewType == .host {
                        PendingHostCard(trips: tripArray, colorScheme: previewType.pendingColorScheme)
                    }
                    
                    if previewType == .request {
                        PendingRequestCard(trips: tripArray, colorScheme: previewType.pendingColorScheme)
                    }
                }
            } else {
                VStack {
                    Text("Nothing Here Yet!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.3717266917, green: 0.3688513637, blue: 0.3725958467, alpha: 1)))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 100)
            }
        }
        .padding(.leading, 20)
        
    }
}

#Preview {
    PendingPreview(previewType: .host, tripData: nil)
}
