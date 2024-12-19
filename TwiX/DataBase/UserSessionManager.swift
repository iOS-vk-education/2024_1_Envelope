//
//  UserManager.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import FirebaseFirestore
import FirebaseAuth

final class UserSessionManager {
    private init() {}
    static let shared = UserSessionManager()
    
    private let db = Firestore.firestore()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isUserLoggedIn: Bool {
        return currentUser != nil
    }
    
    var currentUserEmail: String? {
        return currentUser?.email
    }
    
    func saveUserToDatabase(uid: String, authorName: String, authorUsername: String, authorAvatarURL: URL) {
        let userData: [String: Any] = [
            "authorName": authorName,
            "authorUsername": authorUsername,
            "authorAvatarURL": authorAvatarURL.absoluteString
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully")
            }
        }
    }
    
    func fetchUserFromDatabase(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                // User not found
            }
        }
    }

}
