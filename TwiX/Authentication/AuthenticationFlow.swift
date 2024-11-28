import SwiftUI
import FirebaseAuth

struct AuthenticationFlowView: View {
    var onSuccess: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Header()
                Spacer().frame(maxHeight: Constants.AuthenticationFlow.Spacing.headerTopPadding)
                
                // MARK: - title
                Text(Strings.Authentication.title)
                    .offset(y: 15)
                    .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.AuthenticationFlow.FontSizes.title))
                    .foregroundStyle(.text)
                
                Spacer().frame(maxHeight: Constants.AuthenticationFlow.Spacing.labelPadding)
                
                // MARK: - big social media login buttons
                VStack(spacing: Constants.AuthenticationFlow.Spacing.buttonsSpacing) {
                    AbstractSocialMediaLoginButton(label: Strings.Buttons.continueWithVK, icon: Strings.Icons.vkIconString, action: {})
                    AbstractSocialMediaLoginButton(label: Strings.Buttons.continueWithGoogle, icon: Strings.Icons.googleIconString, action: {})
                    AbstractSocialMediaLoginButton(label: Strings.Buttons.continueWithApple, icon: Strings.Icons.appleIconString, action: {})
                    AbstractSocialMediaLoginButton(label: Strings.Buttons.continueAsGuest, icon: Strings.Icons.guestIconString, action: {signInAnonymously(onSuccess: onSuccess)})
                }
                
                Spacer().frame(height: Constants.AuthenticationFlow.Spacing.dividerSpacing)
                CustomDivider(text: Strings.Dividers.or)
                Spacer().frame(height: Constants.AuthenticationFlow.Spacing.dividerSpacing)
                
                // MARK: - sign in button
                NavigationLink(destination: LoginUIView()) {
                    Text(Strings.Authentication.signInWithPassword)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orangeButton)
                        .cornerRadius(Constants.AuthenticationFlow.Dimensions.buttonCornerRadius)
                        .padding(.horizontal, Constants.AuthenticationFlow.Padding.horizontal)
                }
                
                Spacer().frame(height: Constants.AuthenticationFlow.Spacing.bottomSpacing)
                
                // MARK: - registration hint
                HStack(spacing: 5) {
                    Text(Strings.Authentication.dontHaveAccount)
                        .foregroundStyle(Color.textFieldsBorders)
                    NavigationLink(destination: RegisterUIView()) {
                        Text(Strings.Authentication.signUp)
                            .foregroundStyle(Color.orangeButton)
                    }
                }.font(Font.custom(Fonts.Urbanist_Medium, size: Constants.AuthenticationFlow.FontSizes.signUpText))
                
                Spacer()
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct Header: View {
    var showBackButton: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // MARK: - title in header
            HStack(alignment: .top, spacing: 16) {
                Text(Strings.App.name)
                    .font(Font.custom(Fonts.Urbanist_Bold, size: Constants.Header.FontSizes.title))
                    .foregroundStyle(.text)
                Spacer()
            }
            .padding(.top, Constants.Header.Padding.top)
            .padding(.leading, Constants.Header.Padding.leading)
            
            // MARK: - custom back button logic
            if showBackButton {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: Strings.Icons.backArrow)
                            .foregroundColor(.text)
                            .padding(.top, 3)
                            .padding(.leading, Constants.Header.Padding.leading)
                    }
                    Spacer()
                }
                .padding(.leading, Constants.Header.Padding.backButtonLeading)
            }
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
                NavigationLink(destination: SignUpUIView()) {
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
                }
                
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
}

struct RegisterUIView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                NavigationLink(destination: SignUpUIView()) {
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

struct AbstractSocialMediaLoginButton: View {
    var label: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(label, image: icon)
                .font(Font.custom(Fonts.Urbanist_Medium, size: 16))
                .foregroundColor(.text)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: Constants.Buttons.Dimensions.bigButtonHeight)
                .background(Color.background)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.Buttons.Dimensions.smallButtonCornerRadius)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.Register.Padding.horizontal)
        
    }
}

struct AbstractSocialMediaNoTextButton: View {
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Buttons.Dimensions.iconSize, height: Constants.Buttons.Dimensions.iconSize)
        }
        .frame(width: Constants.Buttons.Dimensions.smallButtonWidth, height: Constants.Buttons.Dimensions.smallButtonHeight)
        .background(Color.background)
        .cornerRadius(Constants.Buttons.Dimensions.smallButtonCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.Buttons.Dimensions.smallButtonCornerRadius)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

struct CustomDivider: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Rectangle().frame(maxWidth: .infinity, maxHeight: 1)
            Text(text).layoutPriority(1)
            Rectangle().frame(maxWidth: .infinity, maxHeight: 1)
        }
        .frame(height: Constants.Divider.height)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, Constants.AuthenticationFlow.Padding.horizontal)
        .font(Font.custom(Fonts.Urbanist_Medium, size: Constants.Login.FontSizes.fieldLabel))
        .foregroundColor(.textFieldsDarker)
    }
}

func signInAnonymously(onSuccess: @escaping () -> Void) {
    Auth.auth().signInAnonymously { result, error in
        if let error = error {
            print("FirebaseAuthError: failed to sign in anonymously: \(error.localizedDescription)")
        } else if let user = result?.user {
            print("FirebaseAuthSuccess: Sign in anonymously, UID: \(user.uid)")
            if Auth.auth().currentUser != nil {
                onSuccess()
            }
        }
    }
}


#Preview {
    AuthenticationFlowView { print("Successful authentication") }
}
