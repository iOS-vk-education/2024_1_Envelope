//
//  Strings.swift
//  TwiX
//
//  Created by Alexander on 11.11.2024.
//

import Foundation


class Strings {
    enum App {
        static let name: String = "TwiX"
    }
    
    enum Icons {
        static let vkIconString: String = "vkIcon"
        static let googleIconString: String = "googleIcon"
        static let appleIconString: String = "appleIcon"
        static let guestIconString: String = "guestIcon"
        
        static let back: String = "chevron.arrow.left"
        
        static let checkboxChecked: String = "icon_checkbox_active"
        static let checkboxUnchecked: String = "icon_checkbox_inactive"
        
    }
    
    enum Headers {
        static let appName = "TwiX"
    }
    
    enum Authentication {
        static let letsYouIn = "Let`s you in"
        static let signInWithPassword = "Sign in with password"
        static let dontHaveAccount = "Don`t have an account?"
        static let signUp = "Sign up"
    }
    
    enum Login {
        static let loginToAccount = "Login to your \nAccount"
        static let email = "Email"
        static let enterEmail = "Enter Email"
        static let password = "Password"
        static let enterPassword = "Enter Password"
        static let rememberMe = "Remember me"
        static let forgotPassword = "Forgor the password?"
        static let orContinueWith = "or continue with"
    }
    
    
    struct Register {
        static let title = "Create Account"
        static let emailLabel = "Email"
        static let emailPlaceholder = "Enter your email"
        static let passwordLabel = "Password"
        static let passwordPlaceholder = "Enter your password"
        static let confirmPasswordLabel = "Confirm Password"
        static let confirmPasswordPlaceholder = "Confirm your password"
        static let signUpButton = "Sign Up"
    }
    
    
    enum Buttons {
        static let continueWithVK = "Continue with VK ID"
        static let continueWithGoogle = "Continue with Google"
        static let continueWithApple = "Continue with Apple"
        static let continueAsGuest = "Continue as Guest"
    }
    
    enum Dividers {
        static let or: String = "or"
        static let orContinueWith: String = "or continue with"
    }
}

