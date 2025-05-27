//
//  DashBoardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashBoardView: View {
    var body: some View {
        NavigationView{
            HStack{
                NavigationLink("Feeling Generous?"){
                    HostTripView()
                }
                NavigationLink("Need Something?"){
                    RequestTripView()
                }
                Button("Get Trips"){
                    Task{
                        do{
                            let trips = try await getTrips()
                            print(trips)
                        } catch TripDataError.invalidURL {
                           print ("invalid URL")
                       }  catch TripDataError.invalidResponse {
                           print ("invalid response")
                       } catch {
                           print ("unexpected error")
                       }
                    }
                }
            }
        }
    }
}


#Preview {
    DashBoardView()
}
