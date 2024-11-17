//
//  IntroUIView.swift
//  TwiX
//
//  Created by Alexander on 17.11.2024.
//

import SwiftUI

struct IntroUIView: View {
    var body: some View {
        // MARK: - Global Stack
        VStack {
            // MARK: - Text Stack
            Header()
            Text("Let`s you in").offset(y: 15).font(Font.custom(Fonts.Urbanist_Bold, size: 40)).foregroundStyle(.text)
            
            Spacer().frame(minHeight: 50, maxHeight: 80)

//            Spacer().frame(height: 50)
            
            // MARK: - Buttons
            VStack(spacing: 16) {
                AbstractButton(label: "Continue with VK ID", icon: Strings.Icons.vkIconString, action: signIn)
                AbstractButton(label: "Continue with Google", icon: Strings.Icons.googleIconString, action: signIn)
                AbstractButton(label: "Continue with Apple", icon: Strings.Icons.appleIconString, action: signIn)
                AbstractButton(label: "Continue as Guest", icon: Strings.Icons.guestIconString, action: signIn)
            }
            Spacer().frame(height: 10)
            CustomDivider()
            Spacer().frame(height: 20)
            Button(action: signIn) {
                Text("Sign in with password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 58)
                    .background(Color.orangeButton)
                    .cornerRadius(100)
            }
            Spacer().frame(height: 75)
            // MARK: - sign up hint
            HStack(spacing: 5) {
                Text("Don`t have an account?").foregroundStyle(Color.textFieldsBorders)
                Button(action: signIn) {
                    Text("Sign up").foregroundStyle(Color.orangeButton)
                }
                
            }.font(Font.custom(Fonts.Urbanist_Medium, size: 12))
            Spacer()
        }.background(Color.background)
    }
}

struct AbstractButton: View {
    var label: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(label, image: icon)
                .font(Font.custom(Fonts.Urbanist_Medium, size: 16))
                .foregroundColor(.text)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .background(Color.background)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
    }
}

struct CustomDivider: View {
    var body: some View {
        HStack(alignment: .center) {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width * 0.72
                HStack {
                    Divider()
                        .frame(width: (totalWidth) / 2, height: 1)
                        .background(.textFieldsDarker)
                    
                    Text("or")
                        .font(Font.custom(Fonts.Urbanist_Medium, size: 16)) .foregroundColor(.textFieldsDarker)
                    
                    Divider()
                        .frame(width: (totalWidth) / 2, height: 1)
                        .background(.textFieldsDarker)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 20)
        }
    }
}


func signIn() {
    
}
struct Header: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Text("TwiX").font(Font.custom(Fonts.Urbanist_Bold, size: 30)).foregroundStyle(.text)
                Spacer()
            }
        }.padding()
    }
}

#Preview {
    IntroUIView()
}
