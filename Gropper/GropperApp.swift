//
//  GropperApp.swift
//  Gropper
//
//  Created by Bryce King on 4/10/25.
//

import SwiftUI

@main
struct GropperApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
