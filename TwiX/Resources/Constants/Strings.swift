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
        
        static let addPostTabBarIcon: String = "addPostTabBarIcon"
        static let mainFeedTabBarIcon: String = "homeTabBarIcon"
        static let searchTabBarIcon: String = "searchTabBarIcon"
        
        static let backArrow: String = "chevron.backward"
        static let customBackArrow: String = "backArrow"
        
        static let checkboxChecked: String = "checkmark.square"
        static let checkboxUnchecked: String = "square"
        static let avatarIcon: String = "avatarIcon"
        static let settingsIcon: String = "settingsIcon"
        static let addPostIcon: String = "addPostIcon"
        
    }
    
    enum Authentication {
        static let title = NSLocalizedString("Let`s log you in", comment: "")
        static let signInWithPassword = NSLocalizedString("Sign in with password", comment: "")
        static let dontHaveAccount = NSLocalizedString("Don`t have an account?", comment: "")
        static let signUp = NSLocalizedString("Sign up", comment: "")
    }
    
    enum Login {
        static let title = NSLocalizedString("Login to your \nAccount", comment: "")
        static let emailLabel = NSLocalizedString("Email", comment: "")
        static let emailPlaceholder = NSLocalizedString("Enter Email", comment: "")
        static let passwordLabel = NSLocalizedString("Password", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Enter Password", comment: "")
        static let rememberMe = NSLocalizedString("Remember me", comment: "")
        static let forgotPassword = NSLocalizedString("Forgor the password?", comment: "")
        static let orContinueWith = NSLocalizedString("or continue with", comment: "")
        static let signIn = NSLocalizedString("Sign in", comment: "")
    }
    
    
    struct Register {
        static let title = NSLocalizedString("Create your \nAccount", comment: "")
        static let emailLabel = NSLocalizedString("Email", comment: "")
        static let emailPlaceholder = NSLocalizedString("Enter your email", comment: "")
        static let passwordLabel = NSLocalizedString("Password", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Enter your password", comment: "")
        static let confirmPasswordLabel = NSLocalizedString("Confirm Password", comment: "")
        static let confirmPasswordPlaceholder = NSLocalizedString("Confirm your password", comment: "")
        static let signUpButton = NSLocalizedString("Sign Up", comment: "")
    }
    
    enum Buttons {
        static let continueWithVK = NSLocalizedString("Continue with VK ID", comment: "")
        static let continueWithGoogle = NSLocalizedString("Continue with Google", comment: "")
        static let continueWithApple = NSLocalizedString("Continue with Apple", comment: "")
        static let continueAsGuest = NSLocalizedString("Continue as Guest", comment: "")
    }
    
    enum Dividers {
        static let or: String = NSLocalizedString("or", comment: "")
        static let orContinueWith: String = NSLocalizedString("or continue with", comment: "")
    }
    
    enum Settings {
        static let teamInfo = NSLocalizedString("team info", comment: "team info")
    }
}

