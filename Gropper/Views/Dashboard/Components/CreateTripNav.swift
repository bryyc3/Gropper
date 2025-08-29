//
//  CreateTripNav.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct CreateTripNav: View {
    @EnvironmentObject var model: DashboardViewModel
    let destination: TripType
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(destination.createTripTitle)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
        
                    Text(destination.createTripSubtitle)
                        .font(.system(size: 15))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                
                Image(destination.createTripImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    
            }
            NavigationLink {
                TripCreationView(formType: destination, onFormSubmit: {model.retrieveTrips()})
            } label: {
                Text(destination.createTripButtonTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 65)
                    .padding(.vertical, 5)
            }
            .foregroundColor(.white)
            .background(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
            .cornerRadius(50)
        }
        .padding(10)
    }
}

#Preview {
    CreateTripNav(destination: .host)
}
