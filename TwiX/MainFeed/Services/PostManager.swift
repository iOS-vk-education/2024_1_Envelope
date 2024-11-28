//
//  PostManager.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import Foundation

class PostManager {
    static let shared = PostManager()
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let mockPosts = [
                Post(id: UUID.init(), text: "Hello World!", authorName: "John", authorUsername: "@boba", authorAvatarURL: URL(string: "https://cataas.com/cat")!, likesCount: 10, commentsCount: 2, timestamp: Date())
            ]
            
            completion(mockPosts)
        }
    }
    
    func likePost(_ postID: UUID) {
        // Increment likes count in database
    }
}
