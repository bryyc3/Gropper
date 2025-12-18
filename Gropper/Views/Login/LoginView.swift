//
//  LoginView.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    var validNumber: Bool {loginViewModel.user.phoneNumber.count == 10}
    
    var body: some View {
        if(!loginViewModel.user.otpGenerated){
            NavigationView {
                VStack{
                    TextField("Enter Your Phone Number", text: $loginViewModel.user.phoneNumber)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    Button("Get Otp"){
                        Task{
                            await loginViewModel.requestOtp()
                        }
                    }
                    .disabled(!validNumber)
                }
            }
        }
        else{
            OtpView(otpViewModel: loginViewModel)
        }
    }
}


