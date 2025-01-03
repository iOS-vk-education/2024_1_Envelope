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
    
    func fetchUserPosts(userId: String, completion: @escaping ([Post]) -> Void) {
        db.collection("posts").whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error loading user's posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var posts: [Post] = []
            for document in querySnapshot?.documents ?? [] {
                if let post = Post(from: document.data(), id: document.documentID) {
                    posts.append(post)
                }
            }
            print("Fetched user's posts: \(posts)")
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
    
    func changeLikeStatus(_ postID: UUID) {
        guard let user = UserSessionManager.shared.currentUser else {
            print("No user is logged in.")
            return
        }

        let db = Firestore.firestore()
        let likesRef = db.collection("likedBy").document(postID.uuidString)

        likesRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            if let document = document, !document.exists {
                likesRef.setData([
                    "likedBy": [user.uid]
                ]) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                        return
                    } else {
                        self.incrementLikeCounter(postID)
                    }
                }
            } else {
                if let likedBy = document?.get("likedBy") as? [String], likedBy.contains(user.uid) {
                    likesRef.updateData([
                        "likedBy": FieldValue.arrayRemove([user.uid])
                    ]) { error in
                        if let error = error {
                            print("Error unliking post: \(error.localizedDescription)")
                        } else {
                            self.decrementLikeCounter(postID)
                        }
                    }
                    return
                }

                likesRef.updateData([
                    "likedBy": FieldValue.arrayUnion([user.uid])
                ]) { error in
                    if let error = error {
                        print("Error liking post: \(error.localizedDescription)")
                    } else {
                        self.incrementLikeCounter(postID)
                    }
                }
            }
        }
    }
    
    private func incrementLikeCounter(_ postID: UUID) {
        let postRef = db.collection("posts").document(postID.uuidString)
        postRef.updateData(["likesCount": FieldValue.increment(Int64(1))])
    }
    
    private func decrementLikeCounter(_ postID: UUID) {
        let postRef = db.collection("posts").document(postID.uuidString)
        postRef.updateData(["likesCount": FieldValue.increment(Int64(-1))])
    }
    
    func isPostLiked(_ postID: UUID, completion: @escaping (Bool) -> Void) {
        guard let user = UserSessionManager.shared.currentUser else {
            print("No user is logged in.")
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let likesRef = db.collection("likedBy").document(postID.uuidString)

        likesRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let document = document, document.exists {
                if let likedBy = document.get("likedBy") as? [String], likedBy.contains(user.uid) {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
