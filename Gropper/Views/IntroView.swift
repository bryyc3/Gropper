//
//  IntroView.swift
//  Gropper
//
//  Created by Bryce King on 2/12/26.
//

import SwiftUI


struct IntroView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(colors: [Color(#colorLiteral(red: 0.275106132, green: 0.3813920915, blue: 0.7452068925, alpha: 1)),Color(#colorLiteral(red: 0.2892701328, green: 0.1013834402, blue: 0.4586637616, alpha: 1)) ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    Text("Gropper")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.476929307, green: 0.8514011502, blue: 0.6683226228, alpha: 1)))
                    VStack{
                        Text("Make Life A Little Easier")
                        TabView {
                            LottieAnimationView(name: "HostAnimation.json", subText: "Let friends and family know where you're heading and you can pick up stuff they need")
                            LottieAnimationView(name: "RequestAnimation.json", subText: "Request for friends or family to pick up items you need from a specific location.")
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(height: 480)
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    
                    NavigationLink(destination: LoginView()){
                        Text("Get Started")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.horizontal, 45)
                            .padding(.vertical, 15)
                            .foregroundColor(.white)
                    }
                        .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                        .cornerRadius(50)
                        
                }
            }
        }
        
    }
}

#Preview {
    IntroView()
}
