//
//  PostManager.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import Foundation
import FirebaseFirestore

class PostManager {
    
    static let shared = PostManager()
    private let db = Firestore.firestore()
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        db.collection("posts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error loading posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var posts: [Post] = []
            for document in querySnapshot?.documents ?? [] {
                if let post = Post(from: document.data(), id: document.documentID) {
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
    
    func addPost(_ post: Post, completion: @escaping (Bool) -> Void) {
        let postData = post.toDocument()
        
        db.collection("posts").document(post.id.uuidString).setData(postData) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                print("Post successfully saved!")
            }
        }
    }
    
    
    func likePost(_ postID: UUID) {
        
    }
}
