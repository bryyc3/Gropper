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
    let characterLimit = 10
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    Text("USER VERIFICATION")
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.5068148971, green: 0.3196431994, blue: 0.8934974074, alpha: 1)))
                    Text("Enter your phone number to receive a verification code")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
                .padding(20)
                TextField("Enter Phone Number", text: $loginViewModel.user.phoneNumber)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(#colorLiteral(red: 0.009296660312, green: 0.7246019244, blue: 0.3760085404, alpha: 1)), lineWidth: 2)
                    )
                    .padding()
                    .onChange(of: loginViewModel.user.phoneNumber) {_, newValue in
                        let filtered = newValue.filter {$0.isNumber}
                        
                        if filtered.count > 10 {
                            loginViewModel.user.phoneNumber = String(filtered.prefix(10))
                        } else {
                            loginViewModel.user.phoneNumber = filtered
                        }
                    }
                NavigationLink("Get OTP", destination: OtpView(otpViewModel: loginViewModel))
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 45)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .background(validNumber ? Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .cornerRadius(50)
                    .disabled(!validNumber)
            }
        }
    }
}


#Preview {
    LoginView()
}



