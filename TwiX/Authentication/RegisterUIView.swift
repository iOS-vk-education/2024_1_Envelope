//
//  RegisterUIView.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import SwiftUI

struct RegisterUIView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistered = false
    
    var onSuccess: () -> Void

    private var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                Header(showBackButton: true)
                Spacer().frame(height: Constants.Register.Spacing.headerTopPadding)
                
                // MARK: - Title
                HStack{
                    Text(Strings.Register.title)
                        .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Register.FontSizes.title))
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Register.Padding.horizontal)
                    Spacer()
                }
                
                Spacer().frame(height: Constants.Register.Spacing.sectionSpacing)
                
                // MARK: - Text fields
                VStack(alignment: .leading, spacing: 5) {
                    
                    // MARK: - email field
                    Text(Strings.Register.emailLabel)
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Register.Padding.horizontal + 10)
                    
                    TextField(Strings.Register.emailPlaceholder, text: $email)
                        .padding()
                        .background(Color.textFieldsBorders)
                        .cornerRadius(Constants.Register.Dimensions.fieldCornerRadius)
                        .padding(.horizontal, Constants.Register.Padding.horizontal)
                    
                    Spacer().frame(height: Constants.Register.Spacing.fieldSpacing)
                    
                    // MARK: - password field
                    Text(Strings.Register.passwordLabel)
                        .foregroundStyle(.text)
                        .padding(.leading, Constants.Register.Padding.horizontal + 10)
                    
                    SecureField(Strings.Register.passwordPlaceholder, text: $password)
                        .padding()
                        .foregroundStyle(.text)
                        .background(Color.textFieldsBorders)
                        .cornerRadius(Constants.Register.Dimensions.fieldCornerRadius)
                        .padding(.horizontal, Constants.Register.Padding.horizontal)
                }.font(Font.custom(Fonts.Urbanist_Light, size: Constants.Register.FontSizes.fieldLabel))
                
                Spacer().frame(maxHeight: Constants.Register.Spacing.bottomSpacing)
                
                // MARK: - Navigation to next screen
                Button(action: register) {
                    Text(Strings.Register.signUpButton)
                        .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Register.FontSizes.fieldLabel))
                        .foregroundColor(Color.orangeButton)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: Constants.Register.Dimensions.buttonHeight)
                        .background(Color.alternativeButtonLight)
                        .cornerRadius(Constants.Register.Dimensions.buttonCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Register.Dimensions.buttonCornerRadius)
                                .stroke(Color.alternativeButtonLight, lineWidth: 1)
                                .shadow(color: Color.alternativeButtonLight.opacity(0.5), radius: Constants.Register.Dimensions.smallCornerRadius, x: 0, y: 0)
                        )
                    
                        .shadow(color: Color.alternativeButtonLight.opacity(0.3), radius: Constants.Register.Dimensions.smallCornerRadius, x: 0, y: 0)
                }.padding(.horizontal, Constants.Register.Padding.horizontal)
                
                Spacer().frame(height: Constants.Register.Spacing.fieldVerticalSpacing)
                
                CustomDivider(text: Strings.Dividers.orContinueWith)
                
                Spacer().frame(height: Constants.Register.Spacing.fieldVerticalSpacing)
                
                // MARK: - Small social media login button
                HStack(spacing: Constants.Register.Spacing.fieldSpacing) {
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
    
    private func register() {
        if (isButtonDisabled) {
            AlertHelper.showAlert(title: "Registration Error", message: "Empty Fields")
        } else {
            AuthService.shared.registerUser(email: email, password: password, onSuccess: {
                isRegistered = true
                onSuccess()
            }, onFailure: {
                msg in
                AlertHelper.showAlert(title: "Registration Error", message: msg)
            })
        }
    }
}
