//
//  UserProfile.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import Foundation

struct UserProfile {
    let authorName: String
    let authorUsername: String
    let authorAvatarURL: URL
    
    init?(data: [String: Any]) {
        guard let name = data["authorName"] as? String,
              let username = data["authorUsername"] as? String,
              let avatarURLString = data["authorAvatarURL"] as? String,
              let avatarURL = URL(string: avatarURLString) else {
            return nil
        }
        
        self.authorName = name
        self.authorUsername = username
        self.authorAvatarURL = avatarURL
    }
}
