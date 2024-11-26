//
//  Strings.swift
//  TwiX
//
//  Created by Alexander on 11.11.2024.
//

import Foundation


enum Strings {
    enum App {
        static let name: String = "TwiX"
    }
    
    enum Icons {
        static let vkIconString: String = "vkIcon"
        static let googleIconString: String = "googleIcon"
        static let appleIconString: String = "appleIcon"
        static let guestIconString: String = "guestIcon"
        
        static let backArrow: String = "chevron.backward"
        
        static let checkboxChecked: String = "checkmark.square"
        static let checkboxUnchecked: String = "square"
        static let avatarIcon: String = "avatarIcon"
        static let settingsIcon: String = "settingsIcon"
        static let addPostIcon: String = "addPostIcon"
        
    }
    
    enum Authentication {
        static let title = "Let`s log you in"
        static let signInWithPassword = "Sign in with password"
        static let dontHaveAccount = "Don`t have an account?"
        static let signUp = "Sign up"
    }
    
    enum Login {
        static let title = "Login to your \nAccount"
        static let emailLabel = "Email"
        static let emailPlaceholder = "Enter Email"
        static let passwordLabel = "Password"
        static let passwordPlaceholder = "Enter Password"
        static let rememberMe = "Remember me"
        static let forgotPassword = "Forgor the password?"
        static let orContinueWith = "or continue with"
        static let signIn = "Sign in"
    }
    
    
    struct Register {
        static let title = "Create your \nAccount"
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

