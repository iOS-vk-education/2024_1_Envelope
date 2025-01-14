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
            removeUserHash(username: updateData["authorUsername"] as! String, uid: uid)
            updateData["authorUsername"] = newAuthorUsername
            addUserHash(username: newAuthorUsername, uid: uid)
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
    
    func logout() {
        cachedProfile = nil
        AuthService.shared.logoutUser(completion: { error in print(error ?? "")})
    }
    
    func initUserToDatabase(uid: String, authorName: String, authorUsername: String, authorBio: String?, authorAvatarURL: URL?) {
        let userRef = db.collection("users").document(uid)

        var updateData: [String: Any] = ["updatedAt": Timestamp()]

        updateData["authorName"] = authorName
        updateData["authorUsername"] = authorUsername
        
        if let newAuthorBio = authorBio {
            updateData["authorBio"] = newAuthorBio
        }
        
        if let newAuthorAvatarURL = authorAvatarURL, UIApplication.shared.canOpenURL(newAuthorAvatarURL) {
            updateData["authorAvatarURL"] = newAuthorAvatarURL.absoluteString
        } else {
            print("Invalid URL: \(authorAvatarURL?.absoluteString ?? "")")
            updateData["authorAvatarURL"] = "https://avatars.mds.yandex.net/i?id=7d3c8e0a5e3e1ea0705bdd6c0139af4b6767cc57-10852819-images-thumbs&n=13"
        }

        addUserHash(username: authorUsername, uid: uid)

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
    
    // MARK: Hash for users

    private func addUserHash(username: String, uid: String) {
        let db = Firestore.firestore()
        let usersHash = db.collection("usersHash")

        var substrings = Set<String>()

        for start in 0..<username.count {
            for end in start+1...username.count {
                let startIndex = username.index(username.startIndex, offsetBy: start)
                let endIndex = username.index(username.startIndex, offsetBy: end)
                let substring = String(username[startIndex..<endIndex])
                substrings.insert(substring)
            }
        }

        for substring in substrings {
            let documentRef = usersHash.document("0_\(substring)")

            documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                } else if let document = document, !document.exists {
                    documentRef.setData([
                        "uuid": [uid]
                    ]) { error in
                        if let error = error {
                            print("Error creating document: \(error.localizedDescription)")
                        }
                    }
                } else {
                    documentRef.updateData([
                        "uuid": FieldValue.arrayUnion([uid])
                    ]) { error in
                        if let error = error {
                            print("Error adding string to array for substring \(substring): \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    private func removeUserHash(username: String, uid: String) {
        let db = Firestore.firestore()
        let usersHash = db.collection("usersHash")

        var substrings = Set<String>()

        for start in 0..<username.count {
            for end in start+1...username.count {
                let startIndex = username.index(username.startIndex, offsetBy: start)
                let endIndex = username.index(username.startIndex, offsetBy: end)
                let substring = String(username[startIndex..<endIndex])
                substrings.insert(substring)
            }
        }

        for substring in substrings {
            let documentRef = usersHash.document("0_\(substring)")

            documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    if var uuidArray = document.data()?["uuid"] as? [String], let index = uuidArray.firstIndex(of: uid) {
                        uuidArray.remove(at: index)
                        if uuidArray.isEmpty {
                            documentRef.delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            documentRef.updateData([
                                "uuid": uuidArray
                            ]) { error in
                                if let error = error {
                                    print("Error updating document: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
