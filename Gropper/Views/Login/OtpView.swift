//
//  OtpView.swift
//  Gropper
//
//  Created by Bryce King on 6/21/25.
//

import SwiftUI

struct OtpView: View {
    @StateObject var otpViewModel: LoginViewModel
    @State private var loginSuccess = true
    @State private var backButtonDisabled = true
    @State private var timeRemaining = 10
    @State private var attemptsRemaining = 5
    
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Enter OTP", text: $otpViewModel.user.otpCode)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), lineWidth: 2)
                    )
                    .padding()
                Button {
                    Task{
                        if(attemptsRemaining > 0) {
                            loginSuccess = try await otpViewModel.checkOtp()
                            attemptsRemaining -= 1
                        }
                    }
                } label: {
                    Text("Login")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 45)
                        .padding(.vertical, 5)
                        
                }
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1)))
                .cornerRadius(50)
                .disabled(attemptsRemaining == 0)
                
                if(loginSuccess == false) {
                    Text("Incorrect password")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
                if(attemptsRemaining == 0) {
                    Text("Too many attempts please wait to try again")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                        .onAppear {
                            Task {
                                try await Task.sleep(for: .seconds(15))
                                attemptsRemaining = 2
                            }
                        }
                }
                if otpViewModel.user.otpGenerated == false {
                    Text("There was an error trying to generate your OTP, please go back and try again")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(backButtonDisabled)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(timeRemaining > 0) {
                    Text("Please wait \(timeRemaining) seconds before going back")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding()
                    
                }
            }
        }
        .onAppear{
            Task{
                await otpViewModel.requestOtp()
                
                while timeRemaining > 0 {
                    try await Task.sleep(for: .seconds(1))
                    timeRemaining -= 1
                }
                
                backButtonDisabled = false
            }
        }
    }
}

#Preview {
    OtpView(otpViewModel: LoginViewModel())
}
