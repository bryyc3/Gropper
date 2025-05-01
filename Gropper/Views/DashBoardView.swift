//
//  DashBoardView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct DashBoardView: View {
    @State var createTripForm: Bool = false
    @State var requestTripForm: Bool = false
    
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
