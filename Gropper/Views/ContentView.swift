//
//  ContentView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        Group{
            if(viewModel.authenticated){
                DashboardView()
            }
            else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
