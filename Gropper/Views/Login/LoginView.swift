//
//  LoginView.swift
//  Gropper
//
//  Created by Bryce King on 6/14/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        if(!loginViewModel.user.otpGenerated){
            NavigationView {
                VStack{
                    TextField("Enter Your Phone Number", text: $loginViewModel.user.phoneNumber)
                        .multilineTextAlignment(.center)
                    Button("Get Otp"){
                        loginViewModel.requestOtp()
                    }
                }
            }
            .onAppear(){
                Task{
                    do{
                        print(try getItem(forKey: "accessToken"))
                        print(try getItem(forKey: "refreeshToken"))
                    }
                }
            }

        }
        else{
            OtpView(otpViewModel: loginViewModel)
        }
    }
}
