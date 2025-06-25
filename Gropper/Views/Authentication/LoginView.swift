//
//  LoginView.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        if(!viewModel.otpGenerated){
            NavigationView {
                VStack{
                    TextField("Enter Your Phone Number", text: $viewModel.phoneNumber)
                        .multilineTextAlignment(.center)
                    Button("Get Otp"){
                        viewModel.requestOtp()
                    }
                }
            }

        }
        else{
            OtpView()
        }
    }
}

#Preview {
    LoginView()
}
