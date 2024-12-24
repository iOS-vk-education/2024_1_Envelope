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
    
    func updateUserToDatabase(uid: String, authorName: String?, authorUsername: String?, authorAvatarURL: URL?) {
        let userRef = db.collection("users").document(uid)
        
        if let newAuthorName = authorName {
            userRef.updateData(["updatedAt": Timestamp(), "authorName": newAuthorName])
        }
        
        if let newAuthorUsername = authorUsername {
            userRef.updateData(["updatedAt": Timestamp(), "authorUsername": newAuthorUsername])
        }
        
        if let newAuthorAvatarURL = authorAvatarURL {
            userRef.updateData(["updatedAt": Timestamp(), "authorAvatarURL": newAuthorAvatarURL])
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
