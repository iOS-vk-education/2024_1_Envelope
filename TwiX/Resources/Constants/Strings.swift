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
        static let title = NSLocalizedString("Authentication.label.title", comment: "")
        static let signInWithPassword = NSLocalizedString("Authentication.label.signPass", comment: "")
        static let dontHaveAccount = NSLocalizedString("Authentication.label.account", comment: "")
        static let signUp = NSLocalizedString("Authentication.label.signUp", comment: "")
    }
    
    enum Login {
        static let title = NSLocalizedString("Login.label.title", comment: "")
        static let emailLabel = NSLocalizedString("Login.label.email", comment: "")
        static let emailPlaceholder = NSLocalizedString("Login.placeholder.email", comment: "")
        static let passwordLabel = NSLocalizedString("Login.lagel.password", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Login.placeholder.password", comment: "")
        static let rememberMe = NSLocalizedString("Login.checkbox.rememberMe", comment: "")
        static let forgotPassword = NSLocalizedString("Login.button.forgotPassword", comment: "")
        static let orContinueWith = NSLocalizedString("Login.label.continueWith", comment: "")
        static let signIn = NSLocalizedString("Login.button.signIn", comment: "")
    }
    
    
    struct Register {
        static let title = NSLocalizedString("Register.label.createAccount", comment: "")
        static let emailLabel = NSLocalizedString("Register.label.email", comment: "")
        static let emailPlaceholder = NSLocalizedString("Register.placeholder.email", comment: "")
        static let passwordLabel = NSLocalizedString("Register.lagel.password", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Register.placeholder.password", comment: "")
        static let confirmPasswordLabel = NSLocalizedString("Register.label.confirmPassword", comment: "")
        static let confirmPasswordPlaceholder = NSLocalizedString("Register.placeholder.confirmPassword", comment: "")
        static let signUpButton = NSLocalizedString("Register.button.signUp", comment: "")
    }
    
    enum Buttons {
        static let continueWithVK = NSLocalizedString("Buttons.continue.vk", comment: "")
        static let continueWithGoogle = NSLocalizedString("Buttons.continue.google", comment: "")
        static let continueWithApple = NSLocalizedString("Buttons.continue.apple", comment: "")
        static let continueAsGuest = NSLocalizedString("Buttons.continue.guest", comment: "")
    }
    
    enum Dividers {
        static let or: String = NSLocalizedString("Divider.or", comment: "")
        static let orContinueWith: String = NSLocalizedString("Divider.orContinueWith", comment: "")
    }
    
    enum Settings {
        static let teamInfo = NSLocalizedString("Settings.label.teamInfo", comment: "")
        static let signOut = NSLocalizedString("Settings.button.signOut", comment: "")
    }
}

