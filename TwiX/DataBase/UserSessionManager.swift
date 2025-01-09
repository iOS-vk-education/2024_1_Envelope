import FirebaseFirestore
import FirebaseAuth

final class UserSessionManager {
    private init() {}
    static let shared = UserSessionManager()
    
    private let db = Firestore.firestore()
    
    private var cachedProfile: UserProfile?
    
    var currentProfile: UserProfile? {
        get {
            if let cachedProfile = cachedProfile {
                return cachedProfile
            }
            loadUserProfile()
            return nil
        }
    }
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isUserLoggedIn: Bool {
        return currentUser != nil
    }
    
    var currentUserEmail: String? {
        return currentUser?.email
    }
    
    func updateUserToDatabase(uid: String, authorName: String?, authorUsername: String?, authorBio: String?, authorAvatarURL: URL?) {
        let userRef = db.collection("users").document(uid)
        
        var updateData: [String: Any] = ["updatedAt": Timestamp()]
        
        if let newAuthorName = authorName {
            updateData["authorName"] = newAuthorName
        }
        
        if let newAuthorUsername = authorUsername {
            updateData["authorUsername"] = newAuthorUsername
        }
        
        if let newAuthorBio = authorBio {
            updateData["authorBio"] = newAuthorBio
        }
        
        if let newAuthorAvatarURL = authorAvatarURL, UIApplication.shared.canOpenURL(newAuthorAvatarURL) {
            updateData["authorAvatarURL"] = newAuthorAvatarURL.absoluteString
        } else {
            print("Invalid URL: \(authorAvatarURL?.absoluteString ?? "")")
        }

        if !updateData.isEmpty {
            userRef.updateData(updateData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        loadUserProfile()
    }

    
    func fetchUserFromDatabase(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                print("User not found")
            }
        }
    }

    func loadUserProfile(completion: ((UserProfile?) -> Void)? = nil) {
        guard let uid = currentUser?.uid else {
            completion?(nil)
            return
        }
        print("UID:")
        print(uid)
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Failed to fetch user profile: \(error)")
                completion?(nil)
                return
            }
            
            guard let data = document?.data(),
                  let profile = UserProfile(data: data) else {
                print("User profile not found or invalid data")
                completion?(nil)
                return
            }
            
            self?.cachedProfile = profile
            completion?(profile)
        }
    }
}
