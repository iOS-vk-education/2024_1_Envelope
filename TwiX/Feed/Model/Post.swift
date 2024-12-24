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
    let mood: [Mood]
    let authorName: String
    // Without "@" prefix
    let authorUsername: String
    let authorAvatarURL: URL?
    var likesCount: Int
    var commentsCount: Int
    let timestamp: Date
    
    init(id: UUID, text: String, mood: [Mood], authorName: String, authorUsername: String, authorAvatarURL: URL, likesCount: Int, commentsCount: Int, timestamp: Date) {
        self.id = id
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.mood = mood
        self.authorName = authorName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.authorUsername = authorUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        self.authorAvatarURL = authorAvatarURL
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.timestamp = timestamp
    }
    
    init?(from document: [String: Any], id: String) {
        guard let text = document["text"] as? String,
              let mood = document["mood"] as? [String],
              let authorName = document["authorName"] as? String,
              let authorUsername = document["authorUsername"] as? String,
              let likesCount = document["likesCount"] as? Int,
              let commentsCount = document["commentsCount"] as? Int,
              let timestamp = document["timestamp"] as? Timestamp,
              let uuid = UUID(uuidString: id)
        else {
            return nil
        }

        self.id = uuid
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.mood = mood.compactMap { Mood(rawValue: $0) }
        self.authorName = authorName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.authorUsername = authorUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        if let authorAvatarURLString = document["authorAvatarURL"] as? String,
           let url = URL(string: authorAvatarURLString) {
            self.authorAvatarURL = url
        } else {
            self.authorAvatarURL = nil
        }
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.timestamp = timestamp.dateValue()
    }
    
    func toDocument() -> [String: Any] {
        return [
            "text": text,
            "mood": mood.map(\.rawValue),
            "authorName": authorName,
            "authorUsername": authorUsername,
            "authorAvatarURL": authorAvatarURL?.absoluteString ?? NSNull(),
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
