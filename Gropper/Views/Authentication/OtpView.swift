//
//  OtpView.swift
//  Gropper
//
//  Created by Bryce King on 6/21/25.
//

import SwiftUI

struct OtpView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter OTP", text: $viewModel.otpCode)
                    .multilineTextAlignment(.center)
                Button("Login") {
                    viewModel.checkOtp()
                }
            }
        }
        
    }
}

#Preview {
    OtpView()
}
