import Foundation
import FirebaseFirestore

extension Array {
    /// Делим массив на чанки фиксированного размера (например, по 10 элементов)
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for i in stride(from: 0, to: count, by: size) {
            let end = index(i, offsetBy: size, limitedBy: count) ?? count
            chunks.append(Array(self[i..<end]))
        }
        return chunks
    }
}

// TODO: Protocol, implement
final class PostManager {
    
    // TODO: replace singltone
    static let shared = PostManager()
    private let db = Firestore.firestore()
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { (querySnapshot, error) in
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
        db.collection("posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { (querySnapshot, error) in
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
    
    func fetchPostsLikedByUser(userId: String, completion: @escaping ([Post]) -> Void) {
        let likesRef = db.collection("likedBy")
        
        // 1. Ищем все документы в "likedBy", где массив "likedBy" содержит userId
        likesRef.whereField("likedBy", arrayContains: userId).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка при поиске likedBy документов: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Пользователь \(userId) не лайкнул ни один пост.")
                completion([])
                return
            }
            
            // 2. Собираем все postIDs (documentID) из коллекции "likedBy"
            let postIDs = documents.map { $0.documentID }
            
            // 3. Теперь нужно сходить в "posts" и найти эти посты
            // Firestore ограничивает запрос 'in' максимум 10 значениями за раз,
            // поэтому делим postIDs на чанки.
            let chunkedIDs = postIDs.chunked(into: 10)
            
            var allPosts: [Post] = []
            let dispatchGroup = DispatchGroup()
            
            for chunk in chunkedIDs {
                dispatchGroup.enter()
                
                self.db.collection("posts")
                    .whereField(FieldPath.documentID(), in: chunk)
                    .getDocuments { snap, err in
                        if let err = err {
                            print("Ошибка при загрузке постов по списку ID: \(err.localizedDescription)")
                            dispatchGroup.leave()
                            return
                        }
                        
                        guard let docs = snap?.documents else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        let posts = docs.compactMap { doc -> Post? in
                            // Инициализируем ваш Post
                            Post(from: doc.data(), id: doc.documentID)
                        }
                        
                        allPosts.append(contentsOf: posts)
                        dispatchGroup.leave()
                    }
            }
            
            // Когда все чанки завершились:
            dispatchGroup.notify(queue: .main) {
                // Если нужно отсортировать, например, по timestamp, сделайте так:
                // allPosts.sort { $0.timestamp > $1.timestamp }
                
                completion(allPosts)
            }
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
