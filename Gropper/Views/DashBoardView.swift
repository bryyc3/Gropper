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
                    CreateTripView()
                }
                NavigationLink("Need Something?"){
                    RequestTripView()
                }
            }
        }
    }
}


#Preview {
    DashBoardView()
}
