//
//  Post.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import Foundation
import FirebaseCore

struct Post {
    let id: UUID
    let text: String
    let authorName: String
    // without "@"
    let authorUsername: String
    let authorAvatarURL: URL
    var likesCount: Int
    var commentsCount: Int
    let timestamp: Date
    
    init(id: UUID, text: String, authorName: String, authorUsername: String, authorAvatarURL: URL, likesCount: Int, commentsCount: Int, timestamp: Date) {
        self.id = id
        self.text = text
        self.authorName = authorName
        self.authorUsername = authorUsername
        self.authorAvatarURL = authorAvatarURL
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.timestamp = timestamp
    }
    
    init?(from document: [String: Any], id: String) {
        guard let text = document["text"] as? String,
              let authorName = document["authorName"] as? String,
              let authorUsername = document["authorUsername"] as? String,
              let authorAvatarURLString = document["authorAvatarURL"] as? String,
              let likesCount = document["likesCount"] as? Int,
              let commentsCount = document["commentsCount"] as? Int,
              let timestamp = document["timestamp"] as? Timestamp,
              let uuid = UUID(uuidString: id)
        else {
            return nil
        }

        self.id = uuid
        self.text = text
        self.authorName = authorName
        self.authorUsername = authorUsername
        self.authorAvatarURL = URL(string: authorAvatarURLString) ?? URL(string: "https://example.com")!
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.timestamp = timestamp.dateValue()
    }
    
    // TODO: Migrate model transforming into controller
    
    func toDocument() -> [String: Any] {
        return [
            "text": text,
            "authorName": authorName,
            "authorUsername": authorUsername,
            "authorAvatarURL": authorAvatarURL.absoluteString,
            "likesCount": likesCount,
            "commentsCount": commentsCount,
            "timestamp": timestamp
        ]
    }
    

    static func formatTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MMM yyyy"
        return dateFormatter.string(from: timestamp)
    }
}
