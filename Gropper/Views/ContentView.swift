//
//  ContentView.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @State var authenticated: Bool = AuthManager.shared.authStatus()
    
    var body: some View {
        Group{
            if(authenticated){
                DashboardView()
            }
            else{
                LoginView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .login)){_ in
            authenticated = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .logout)){_ in
            authenticated = false
        }
    }
}

#Preview {
    ContentView()
}
