//
//  DashboardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var model: TripsViewModel
    @State private var logout = false
    @State private var deleteAccount = false
    @State private var logoutSuccess: ApiResponse = ApiResponse(status200: true, message: nil)
    @State private var deleteAccountSuccess: ApiResponse = ApiResponse(status200: true, message: nil)
    @State private var getTrips: ApiResponse = ApiResponse(status200: true, message: nil)
    
    var body: some View {
        NavigationStack{
            VStack{
                CreateTripNav()
                ScrollView(.vertical){
                    VStack{
                        TripPreview(previewType: .host, tripData: model.confirmedHostedTrips)
                        TripPreview(previewType: .request, tripData: model.confirmedRequestedTrips)
                        
                        Button("Logout") {
                            logout.toggle()
                        }
                        .confirmationDialog("Are you sure you want to logout?", isPresented: $logout) {
                            Button(role: .destructive) {
                                Task {
                                    logoutSuccess = try await AuthManager.shared.logout()
                                }
                            } label: {
                                Text("Logout")
                            }
                        } message: {
                            Text("Are you sure you want to logout?")
                        }
                        if(logoutSuccess.status200 == false){
                            Text(logoutSuccess.message!)
                                .foregroundColor(.red)
                        }
                        
                        Button("Delete Account") {
                            deleteAccount.toggle()
                        }
                        .confirmationDialog("Are you sure you want to delete all current data associated with your phone number/account?", isPresented: $deleteAccount) {
                            Button(role: .destructive) {
                                Task {
                                    deleteAccountSuccess = try await model.deleteAccountData()
                                }
                            } label: {
                                Text("Delete Account")
                            }
                        } message: {
                            Text("Are you sure you want to delete all current data associated with your phone number/account?")
                        }
                        if(deleteAccountSuccess.status200 == false){
                            Text(deleteAccountSuccess.message!)
                                .foregroundColor(.red)
                        }
                        
                        if (getTrips.status200 == false) {
                            Text(getTrips.message ?? "Error Getting Trips Youre Apart Of")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .scrollIndicators(ScrollIndicatorVisibility.never)
                .refreshable {
                    Task{
                        getTrips = try await model.retrieveTrips()
                    }
                }
            }
            .padding(7)
        }
    }
}
