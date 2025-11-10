//
//  CreateTripNav.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct CreateTripNav: View {
    
    var body: some View {
        VStack(spacing: -10){
            HStack{
                VStack{
                    Text("Feeling Generous?")
                        .padding(.leading, 15)
                }
                
                Spacer()
                VStack{
                    Text("Need Something?")
                        .padding(.trailing, 15)
                }
                
            }
            .padding(.top, 20)
            .foregroundColor(Color(#colorLiteral(red: 0.487426579, green: 0.3103705347, blue: 0.853105247, alpha: 1)))
            .font(.system(size: 18, weight: .bold))
                    
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    VStack(spacing: 0){
                        Rectangle()
                            .frame(width: 90, height: 2)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                            .offset(x: -95)
                            .padding(.top, 2)
                        CreateTripDestination(destination: .host)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                    
                    VStack(spacing: 0){
                        Rectangle()
                            .frame(width: 90, height: 2)
                            .foregroundColor(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                            .offset(x: 85)
                            .padding(.top, 2)
                        CreateTripDestination(destination: .request)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(10, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Gradient(colors: [Color(#colorLiteral(red: 0.7062481642, green: 0.8070108294, blue: 0.9882084727, alpha: 1)),Color(#colorLiteral(red: 0.5758828521, green: 0.4828243852, blue: 0.8095962405, alpha: 1))])))
        .padding(.vertical, 20)
    }
}

#Preview {
    CreateTripNav()
}
