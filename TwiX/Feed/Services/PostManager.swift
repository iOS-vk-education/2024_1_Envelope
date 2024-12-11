//
//  PostManager.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import Foundation
import FirebaseFirestore


// TODO: Protocol, implement
final class PostManager {
    
    // TODO: replace singltone
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
            print("Fetched posts: \(posts)")
            completion(posts)
        }
    }
    
    func addPost(_ post: Post) {
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
        let postRef = db.collection("posts").document(postID.uuidString)
        postRef.updateData(["likesCount": FieldValue.increment(Int64(1))])
    }
}
