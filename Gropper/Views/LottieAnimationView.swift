//
//  LottieAnimationView.swift
//  Gropper
//
//  Created by Bryce King on 2/14/26.
//

import SwiftUI
import Lottie

struct LottieAnimationView: View {
    let name: String
    let subText: String
    
    var body: some View {
        VStack {
            LottieView(animation: .named(name))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .frame(width: 300, height: 300)
            Text(subText)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

//#Preview {
//    LottieAnimationView()
//}
