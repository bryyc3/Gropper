//
//  OtpView.swift
//  Gropper
//
//  Created by Bryce King on 6/21/25.
//

import SwiftUI

struct OtpView: View {
    @StateObject var otpViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter OTP", text: $otpViewModel.user.otpCode)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.never)
                Button("Login") {
                    otpViewModel.checkOtp()
                }
            }
        }
        
    }
}

//#Preview {
//    OtpView()
//}
