import SwiftUI
import FirebaseAuth

struct AuthenticationFlowView: View {
    var onSuccess: () -> Void
    @State private var isAuthenticated: Bool = false
    
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
                    AbstractSocialMediaLoginButton(label: Strings.Buttons.continueAsGuest, icon: Strings.Icons.guestIconString) {
                        AuthService.shared.signInAnonymously {
                            isAuthenticated = true
                            onSuccess()
                        }
                    }
                }
                
                Spacer().frame(height: Constants.AuthenticationFlow.Spacing.dividerSpacing)
                CustomDivider(text: Strings.Dividers.or)
                Spacer().frame(height: Constants.AuthenticationFlow.Spacing.dividerSpacing)
                
                // MARK: - sign in button
                NavigationLink(destination: LoginUIView(onSuccess: onSuccess)) {
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
                    NavigationLink(destination: RegisterUIView(onSuccess: onSuccess)) {
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
                        Image(Strings.Icons.backArrow)
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

#Preview {
    AuthenticationFlowView { print("Successful authentication") }
}
