import UIKit
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import GoogleSignIn

@main
struct AuthLoginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authManager: AuthManager

    init() {
        FirebaseApp.configure()
        
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
    }

    var body: some Scene {
        WindowGroup {
            AuthenticationFlowUIView()
                .environmentObject(authManager)
        }
    }
}
