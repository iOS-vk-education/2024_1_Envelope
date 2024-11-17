//
//  IntroUIView.swift
//  TwiX
//
//  Created by Alexander on 17.11.2024.
//

import SwiftUI

struct Header: View {
    var showBackButton: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Text("TwiX")
                    .font(Font.custom(Fonts.Urbanist_Bold, size: 30))
                    .foregroundStyle(.text)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            
            if showBackButton {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.text)
                            .padding(.top, 3)
                            .padding(.leading, 10)
                            .animation(.easeInOut)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
            }
        }
    }
}

struct AuthenticationFlowUIView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Header()
                Spacer().frame(height: 50)
                Text("Let`s you in")
                    .offset(y: 15)
                    .font(Font.custom(Fonts.Urbanist_Bold, size: 40))
                    .foregroundStyle(.text)
                
                Spacer().frame(minHeight: 50, maxHeight: 80)
                
                VStack(spacing: 16) {
                    AbstractButton(label: "Continue with VK ID", icon: Strings.Icons.vkIconString, action: signIn)
                    AbstractButton(label: "Continue with Google", icon: Strings.Icons.googleIconString, action: signIn)
                    AbstractButton(label: "Continue with Apple", icon: Strings.Icons.appleIconString, action: signIn)
                    AbstractButton(label: "Continue as Guest", icon: Strings.Icons.guestIconString, action: signIn)
                }
                Spacer().frame(height: 10)
                CustomDivider(text: "or")
                Spacer().frame(height: 20)
                
                NavigationLink(destination: LoginUIView()) {
                    Text("Sign in with password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 58)
                        .background(Color.orangeButton)
                        .cornerRadius(100)
                }
                
                Spacer().frame(height: 75)
                
                HStack(spacing: 5) {
                    Text("Don`t have an account?")
                        .foregroundStyle(Color.textFieldsBorders)
                    Button(action: signIn) {
                        Text("Sign up")
                            .foregroundStyle(Color.orangeButton)
                    }
                }.font(Font.custom(Fonts.Urbanist_Medium, size: 12))
                Spacer()
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LoginUIView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRememberMeChecked: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Header(showBackButton: true)
                Spacer().frame(height: 40)
                
                HStack{
                    Text("Login to your \nAccount")
                        .font(Font.custom(Fonts.Urbanist_Bold, size: 40))
                        .foregroundStyle(.text)
                        .padding(.leading, 30)
                    Spacer()
                }
                
                Spacer().frame(height: 25)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .foregroundStyle(.text)
                        .padding(.leading, 40)
                    
                    TextField("Enter Email", text: $email)
                        .padding()
                        .background(Color.textFieldsBorders)
                        .cornerRadius(8)
                        .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 15)
                    
                    Text("Password")
                        .foregroundStyle(.text)
                        .padding(.leading, 40)
                    SecureField("Enter Password", text: $password)
                        .padding()
                        .foregroundStyle(.text)
                        .background(Color.textFieldsBorders)
                        .cornerRadius(8)
                        .padding(.horizontal, 30)
                }.font(Font.custom(Fonts.Urbanist_Light, size: 16))
                
                Spacer().frame(height: 20)
                HStack(alignment: .center) {
                    Button(action: {
                        isRememberMeChecked.toggle()
                    }) {
                        Image(systemName: isRememberMeChecked ? "checkmark.square" : "square")
                            .foregroundColor(Color.orangeButton)
                    }
                    
                    Text("Remember me")
                        .font(Font.custom(Fonts.Urbanist_Light, size: 16))
                        .foregroundStyle(.text)
                }
                Spacer().frame(height: 20)
                
                
                NavigationLink(destination: SignUpUIView()) {
                    Text("Sign Up")
                        .font(Font.custom(Fonts.Urbanist_Bold, size: 16))
                        .foregroundColor(Color.orangeButton)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 58)
                        .background(Color.alternativeButtonLight)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.alternativeButtonLight, lineWidth: 1)
                                .shadow(color: Color.alternativeButtonLight.opacity(0.5), radius: 10, x: 0, y: 0)
                        )
                        .shadow(color: Color.alternativeButtonLight.opacity(0.3), radius: 10, x: 0, y: 0)
                }
                
                
                Spacer()
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SignUpUIView: View {
    var body: some View {
        VStack {
            Text("Sign Up View")
                .font(.largeTitle)
        }
        .background(Color.white)
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
    var text: String
    var body: some View {
        HStack(alignment: .center) {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width * 0.72
                HStack {
                    Divider()
                        .frame(width: (totalWidth) / 2, height: 1)
                        .background(.textFieldsDarker)
                    
                    Text(text)
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

func signIn() {}

#Preview {
    AuthenticationFlowUIView()
}

