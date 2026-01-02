//
//  CreateTripNav.swift
//  Gropper
//
//  Created by Bryce King on 7/22/25.
//

import SwiftUI

struct CreateTripNav: View {

    enum Page: Int {
        case host
        case request
    }

    @State private var selectedPage: Page = .host
    @Namespace private var underlineNamespace

    var body: some View {
        VStack(spacing: -10) {
            HStack {
                headerItem(
                    title: "Feeling Generous?",
                    page: .host
                )
                Spacer()
                headerItem(
                    title: "Need Something?",
                    page: .request
                )
            }
            .padding(.top, 20)
            .foregroundColor(Color(#colorLiteral(red: 0.487426579, green: 0.3103705347, blue: 0.853105247, alpha: 1)))
            .font(.system(size: 18, weight: .bold))

            TabView(selection: $selectedPage) {
                CreateTripDestination(destination: .host)
                    .tag(Page.host)
                CreateTripDestination(destination: .request)
                    .tag(Page.request)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    Gradient(colors: [
                        Color(#colorLiteral(red: 0.7062481642, green: 0.8070108294, blue: 0.9882084727, alpha: 1)),
                        Color(#colorLiteral(red: 0.5758828521, green: 0.4828243852, blue: 0.8095962405, alpha: 1))
                    ])
                )
        )
        .padding(.vertical, 50)
    }

    private func headerItem(title: String, page: Page) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedPage = page
                    }
                }
            ZStack {
                if selectedPage == page {
                    Rectangle()
                        .frame(width: 90, height: 2)
                        .foregroundColor(
                            Color(#colorLiteral(red: 0.08564137667, green: 0.3184491694, blue: 0.6205952168, alpha: 1))
                        )
                        .matchedGeometryEffect(
                            id: "underline",
                            in: underlineNamespace
                        )
                } else {
                    Color.clear.frame(height: 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CreateTripNav()
}
