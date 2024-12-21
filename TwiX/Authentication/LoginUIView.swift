//
//  LoginUIView.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import SwiftUI

struct LoginUIView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isRememberMeChecked: Bool = false
    @State private var isButtonTemporarilyDisabled: Bool = false
    
    var onSuccess: () -> Void
    
    private var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Header(showBackButton: true)
                Spacer().frame(height: Constants.Login.Spacing.headerTopPadding)
                
                // MARK: - title
                HStack{
                    Text(Strings.Login.title)
                        .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Login.FontSizes.title))
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Login.Padding.horizontal)
                    Spacer()
                }
                
                Spacer().frame(height: Constants.Login.Spacing.sectionSpacing)
                
                // MARK: - Text fields
                VStack(alignment: .leading, spacing: 5) {
                    // MARK: - email field
                    Text(Strings.Login.emailLabel)
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Login.Padding.horizontal + 10)
                    
                    TextField(Strings.Login.emailPlaceholder, text: $email)
                        .padding()
                        .background(Color.textFieldsBorders)
                        .cornerRadius(8)
                        .padding(.horizontal, Constants.Login.Padding.horizontal)
                    
                    Spacer().frame(height: Constants.Login.Spacing.fieldSpacing)
                    
                    // MARK: - password field
                    Text(Strings.Login.passwordLabel)
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Login.Padding.horizontal + 10)
                    SecureField(Strings.Login.passwordPlaceholder, text: $password)
                        .padding()
                        .foregroundStyle(.text)
                        .background(Color.textFieldsBorders)
                        .cornerRadius(8)
                        .padding(.horizontal, Constants.Login.Padding.horizontal)
                }.font(Font.custom(Fonts.Urbanist_Light, size: Constants.Login.FontSizes.fieldLabel))
                
                Spacer().frame(height: Constants.Login.Spacing.fieldSpacing)
                
                // MARK: - "Remember me" checkbox
                HStack(alignment: .center) {
                    Button(action: {
                        isRememberMeChecked.toggle()
                    }) {
                        Image(systemName: isRememberMeChecked ? Strings.Icons.checkboxChecked : Strings.Icons.checkboxUnchecked)
                            .foregroundColor(Color.orangeButton)
                        Text(Strings.Login.rememberMe)
                            .font(Font.custom(Fonts.Urbanist_Light, size: Constants.Login.FontSizes.fieldLabel))
                            .foregroundStyle(.text)
                    }
                }
                
                Spacer().frame(height: Constants.Login.Spacing.fieldSpacing)
                
                // MARK: - Navigation to next screen
                Button(action: login) {
                    Text(Strings.Login.signIn)
                        .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Login.FontSizes.fieldLabel))
                        .foregroundColor(Color.orangeButton)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: Constants.Login.Dimensions.buttonHeight)
                        .background(Color.alternativeButtonLight)
                        .cornerRadius(Constants.Login.Dimensions.buttonCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Login.Dimensions.buttonCornerRadius)
                                .stroke(Color.alternativeButtonLight, lineWidth: 1)
                                .shadow(color: Color.alternativeButtonLight.opacity(0.5), radius: Constants.Login.Dimensions.smallCornerRadius, x: 0, y: 0)
                        )
                        .shadow(color: Color.alternativeButtonLight.opacity(0.3), radius: Constants.Login.Dimensions.smallCornerRadius, x: 0, y: 0)
                        .padding(.horizontal, Constants.Login.Padding.horizontal)
                }.disabled(isButtonTemporarilyDisabled)
                
                Spacer().frame(height: Constants.Login.Spacing.fieldSpacing)
                
                // MARK: - Forgot password hint
                Button(action: {}) {
                    Text(Strings.Login.forgotPassword).font(Font.custom(Fonts.Urbanist_Medium, size: Constants.Login.FontSizes.smallText))
                        .foregroundColor(Color.orangeButton)
                }
                
                Spacer().frame(height: Constants.Login.Spacing.bottomSpacing)
                CustomDivider(text: Strings.Dividers.orContinueWith)
                Spacer().frame(height: Constants.Login.Spacing.sectionSpacing)
                
                // MARK: - Small social media login button
                HStack(spacing: Constants.Login.Spacing.fieldSpacing) {
                    AbstractSocialMediaNoTextButton(icon: Strings.Icons.vkIconString, action: {})
                    AbstractSocialMediaNoTextButton(icon: Strings.Icons.googleIconString, action: {})
                    AbstractSocialMediaNoTextButton(icon: Strings.Icons.appleIconString, action: {})
                }
                
                Spacer()
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    private func login() {
        isButtonTemporarilyDisabled = true
        if (isButtonDisabled) {
            AlertHelper.showAlert(title: "Login Error", message: "Empty Fields")
            isButtonTemporarilyDisabled = false
        } else {
            AuthService.shared.loginUser(email: email, password: password,
             onSuccess: {
                onSuccess()
                isButtonTemporarilyDisabled = false
            }, onFailure: { msg in
                AlertHelper.showAlert(title: "Login error", message: msg)
                isButtonTemporarilyDisabled = false
            })
        }
    }
}
