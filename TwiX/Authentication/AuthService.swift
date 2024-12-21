//
//  AuthService.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    private let db = Firestore.firestore()
    private let userSession = UserSessionManager.shared
    
    func registerUser(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                onFailure("Failed to check user existence: \(error.localizedDescription)")
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                onFailure("User already exists with this email.")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    onFailure("Failed to register: \(error.localizedDescription)")
                    return
                }
                
                guard let user = authResult?.user else {
                    onFailure("Failed to retrieve user information.")
                    return
                }
                
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "email": email,
                    "updatedAt": Timestamp(),
                    "authorName": String(email.prefix(through: email.firstIndex(of: "@")!)),
                    "authorUsername": String(email.prefix(through: email.firstIndex(of: "@")!)),
                    "authorAvatarURL": ""
                ]
                self.db.collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        onFailure("Failed to save user data: \(error.localizedDescription)")
                        return
                    }
                    print("FirebaseAuth: User registered successfully, UID: \(user.uid)")
                    onSuccess()
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                onFailure("Failed to check user existence: \(error.localizedDescription)")
                return
            }

            if let documents = querySnapshot?.documents, documents.isEmpty {
                onFailure("No user found with this email.")
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    onFailure("Failed to login: \(error.localizedDescription)")
                    return
                }
                print("FirebaseAuthSuccess: Login successful, UID: \(authResult!.user.uid)")
                onSuccess()
            }
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
    
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}

