import Foundation
import FirebaseFirestore

struct UserProfile {
    let authorName: String
    let authorUsername: String
    //let authorBio: String?
    let authorAvatarURL: URL?
    
    init(authorName: String, authorUsername: String, /*authorBio: String?,*/ authorAvatarURL: URL?) {
        self.authorName = authorName
        self.authorUsername = authorUsername
        //self.authorBio = authorBio
        self.authorAvatarURL = authorAvatarURL
    }
    
    init?(data: [String: Any]) {
        guard let name = data["authorName"] as? String,
              let username = data["authorUsername"] as? String/*,
              let userBio = data["authorBio"] as? String*/ else {
            return nil
        }
        
        self.authorName = name
        self.authorUsername = username
        //self.authorBio = userBio
        
        if let avatarURLString = data["authorAvatarURL"] as? String,
           let avatarURL = URL(string: avatarURLString) {
            self.authorAvatarURL = avatarURL
        } else {
            self.authorAvatarURL = nil
        }
    }
}
