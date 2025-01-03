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
        
        static let addPostTabBarIcon: String = "AddPostTabBarIcon"
        static let mainFeedTabBarIcon: String = "HomeTabBarIcon"
        static let searchTabBarIcon: String = "SearchTabBarIcon"
        
        static let backArrow: String = "backArrow"
        
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
    
    enum Profile {
        static let following: String = "following"
        static let followers: String = "followers"
        static let editProfile: String = "Edit profile"
        static let posts: String = "Posts"
        static let likes: String = "Likes"
    }
    enum Settings {
        static let teamInfo = "developed by team Envelope on course of VK Education in ITMO University\n\nAlexander Filatov\nAlexey Tsvetkov\nAndrew Shustrov\nEgor Ulin";
    }
}

