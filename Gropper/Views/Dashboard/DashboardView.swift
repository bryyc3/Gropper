//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(spacing: -10){
                    HStack{
                        Text("Feeling Generous?")
                            .padding(.leading, 15)
                        Spacer()
                        Text("Need Something?")
                            .padding(.trailing, 15)
                            
                    }
                    .padding(.top, 20)
                    .foregroundColor(Color(#colorLiteral(red: 0.487426579, green: 0.3103705347, blue: 0.853105247, alpha: 1)))
                    .font(.system(size: 18, weight: .bold))
                    
                    
                    ScrollView(.horizontal){
                        HStack{
                            CreateTripNav(destination: .host)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            CreateTripNav(destination: .request)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        }
                        .scrollTargetLayout()
                        
                    }
                    .contentMargins(10, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                }
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Gradient(colors: [Color(#colorLiteral(red: 0.7062481642, green: 0.8070108294, blue: 0.9882084727, alpha: 1)),Color(#colorLiteral(red: 0.5758828521, green: 0.4828243852, blue: 0.8095962405, alpha: 1))])))
                
                TripPreview(previewType: .host, tripData: viewModel.hostedTrips)
                TripPreview(previewType: .request, tripData: viewModel.requestedTrips)
                
                Spacer()
            }
            .padding()
        }
        
        .environmentObject(viewModel)
        .onAppear{viewModel.retrieveTrips()}
    }
}

#Preview {
    DashboardView()
}
