import UIKit
import FirebaseFirestore

final class FeedView : UIView {
    
    // MARK: - Private properties
    
    private let postManager = PostManager.shared
    let tableView = UITableView()
    private var errorAction: ((String) -> Void)?
    var posts: [Post] = []
    private var query: Query
    var navigationController: UINavigationController?
    
    // MARK: - Initializers
    
    init(frame: CGRect = .zero, query: Query = Firestore.firestore().collection("posts").order(by: "timestamp", descending: true)) {
        self.query = query
        super.init(frame: frame)
        setupView()
        loadPosts()
    }
    
    required init?(coder: NSCoder) {
        self.query = Firestore.firestore().collection("posts").order(by: "timestamp", descending: true)
        super.init(coder: coder)
        setupView()
        loadPosts()
    }
    
    // MARK: - Public functions
    
    public func loadPosts() {
        postManager.fetchPosts(with: query) { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    public func loadUserPosts(userId: String) {
        let tmp = query
        query = Firestore.firestore().collection("posts")
            .whereField("authorUsername", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
        loadPosts()
        query = tmp
    }
    
    public func loadLikedPosts(uid: String) {
        Firestore.firestore().collection("likedBy")
            .whereField("likedBy", arrayContains: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching liked documents: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No liked documents found")
                    return
                }
                
                let postIds = documents.map { $0.documentID }
                if !postIds.isEmpty {
                    self.query = Firestore.firestore().collection("posts")
                        .whereField(FieldPath.documentID(), in: postIds)
                    self.loadPosts()
                } else {
                    print("No posts found for the user")
                }
            }
    }

    
    public func setErrorAction(_ action: @escaping ((String) -> Void)) {
        errorAction = action
    }
}

// MARK: Private action handlers

private extension FeedView {
    func changeLikeStatus(at indexPath: IndexPath) {
        var post = posts[indexPath.row]
        
        guard let cell = self.tableView.cellForRow(at: indexPath) as? PostTableViewCell else {
            return
        }
        
        cell.changeEnable(false)
        
        PostManager.shared.isPostLiked(post.id) { [weak self] isLiked in
            guard let self else { return }
            self.postManager.changeLikeStatus(post.id) { likes, isLiked in
                post.likesCount = likes
                print(likes, isLiked)
                print("change Likes")
                cell.updateLikesCount(post.likesCount, isLiked)
                
                self.posts[indexPath.row] = post
                
                cell.changeEnable(true)
            }
        }
    }
    
    func presentFullPost(_ post: Post) {
        guard let parentVC = findViewController() else { return }
        let detailVC = PostDetailViewController(post: post)
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.modalTransitionStyle = .coverVertical
        parentVC.present(detailVC, animated: true)
    }
}

// MARK: - Private setup functions

private extension FeedView {
    func setupView() {
        setupTableView()
        setup()
        layout()
    }
    
    func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setup() {
        addSubview(tableView)
        tableView.backgroundColor = self.backgroundColor
        tableView.separatorColor = UIColor.black
    }
    
    func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Table view logic

extension FeedView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        presentFullPost(selectedPost)
    }
    
  
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .background
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PostTableViewCell.self),
            for: indexPath
        ) as? PostTableViewCell else { return PostTableViewCell() }
        cell.backgroundColor = self.backgroundColor
        cell.selectionStyle = .none
        cell.configure(
            with: posts[indexPath.row],
            likeAction: { [weak self] in
                self?.changeLikeStatus(at: indexPath)
            },
            avatarTapAction: { [weak self] in
                guard let self = self else { return }
                self.navigateToUserProfile(username: self.posts[indexPath.row].authorUsername)
            },
            errorAction: errorAction ?? { _ in }
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let post = posts[indexPath.row]
        guard let currentUsername = UserSessionManager.shared.currentProfile?.authorUsername else {
            return false
        }
        return post.authorUsername == currentUsername
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            let alert = UIAlertController(title: "Delete Post?",
                                          message: "Are you sure you want to delete this post?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.postManager.deletePost(post.id) { success in
                    if success {
                        self.posts.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
            if let vc = self.findViewController() {
                vc.present(alert, animated: true)
            }
        }
    }
}

private extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        }
        return nil
    }
}

extension FeedView {
    private func navigateToUserProfile(username: String) {
        let query = Firestore.firestore()
            .collection("users")
            .whereField("authorUsername", isEqualTo: username)
            .limit(to: 1)
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                self.errorAction?("Не удалось загрузить профиль пользователя.")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("User not found for username: \(username)")
                self.errorAction?("Пользователь не найден.")
                return
            }
            
            guard let user = UserProfile(data: document.data()) else {
                print("Invalid user data for document: \(document.documentID)")
                self.errorAction?("Некорректные данные профиля.")
                return
            }
            
            DispatchQueue.main.async {
                if let navigationController = self.navigationController {
                    let profileController = ProfileController(user: user)
                    navigationController.pushViewController(profileController, animated: true)
                }
            }
        }
    }
}
