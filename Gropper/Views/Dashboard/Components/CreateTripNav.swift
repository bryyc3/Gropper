//
//  CreateTripButton.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct CreateTripButton: View {
    @EnvironmentObject var model: DashboardViewModel
    let destination: TripType
    
    var body: some View {
        
        NavigationLink {
            TripCreationView(formType: destination, onFormSubmit: {model.retrieveTrips()})
        } label: {
            VStack{
                VStack(alignment: .leading){
                    HStack(){
                        Text(destination.createTripButtonTitle)
                            .font(.system(size: 20))
                            .frame(width: 120, alignment: .leading)
                            .multilineTextAlignment(    .leading)
                            .fontWeight(.bold)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                    }
                    Text(destination.createTripButtonSubtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }
                .padding(20)
            }
            .background(LinearGradient(colors: [Color(#colorLiteral(red: 0.5393404365, green: 0.7348515391, blue: 0.981480062, alpha: 0.9684395696)), Color(#colorLiteral(red: 0.5016872287, green: 0.6910412312, blue: 0.9652110934, alpha: 1)), Color(#colorLiteral(red: 0.5207725167, green: 0.7111770511, blue: 0.9870730042, alpha: 0.9739497103))], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(25)
            
        }
        
    }
}

#Preview {
    CreateTripButton(destination: .host)
}
