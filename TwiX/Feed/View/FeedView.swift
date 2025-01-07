import UIKit

final class FeedView : UIView {
    
    // MARK: - Private properties
    
    private let postManager = PostManager.shared
    let tableView = UITableView()
    private var errorAction: ((String) -> Void)?
    var posts: [Post] = []
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadPosts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        loadPosts()
    }
    
    // MARK: - Public functions
    
    public func loadPosts() {
        postManager.fetchPosts { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    public func loadUserPosts(userId: String) {
        postManager.fetchUserPosts(userId: userId) { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
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
            self.postManager.changeLikeStatus(post.id)
            
            if !isLiked {
                post.likesCount += 1
                cell.updateLikesCount(post.likesCount, true)
            } else {
                post.likesCount -= 1
                cell.updateLikesCount(post.likesCount, false)
            }
            
            posts[indexPath.row] = post
            
            cell.changeEnable(true)
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .background
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as? PostTableViewCell else { return PostTableViewCell() }
        cell.backgroundColor = self.backgroundColor
        cell.selectionStyle = .none
        let post = posts[indexPath.row]
        cell.configure(with: post, likeAction: { [weak self] in
            guard let self = self else { return }
            self.changeLikeStatus(at: indexPath)
        }, errorAction: errorAction ?? { _ in })
        return cell
    }
}
