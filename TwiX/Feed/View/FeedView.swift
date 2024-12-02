//
//  FeedView.swift
//  TwiX
//
//  Created by Alexander on 02.12.2024.
//

import UIKit

class FeedView : UIView {
    
    // MARK: - Private properties
    
    private let tableView = UITableView()
    private let postManager = PostManager.shared
    private var posts: [Post] = []
    
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
    
    // Public functions
    
    public func loadPosts() {
        postManager.fetchPosts { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: Private action handlers

private extension FeedView {
    func likePost(at indexPath: IndexPath) {
        var post = posts[indexPath.row]
        post.likesCount += 1
        posts[indexPath.row] = post
        PostManager.shared.likePost(post.id)
        
        if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
            cell.updateLikesCount(post.likesCount)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post) { [weak self] in
            guard let self = self else { return }
            self.likePost(at: indexPath)
        }
        return cell
    }
}
