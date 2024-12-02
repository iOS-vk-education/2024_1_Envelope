//
//  FeedViewController.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import UIKit

class FeedViewController: UIViewController {
    private let tableView = UITableView()
    private let postManager = PostManager.shared
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPosts()
    }
    
    private func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public func loadPosts() {
        postManager.fetchPosts { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    private func likePost(at indexPath: IndexPath) {
        var post = posts[indexPath.row]
        post.likesCount += 1
        posts[indexPath.row] = post
        PostManager.shared.likePost(post.id)

        if let cell = self.tableView.cellForRow(at: indexPath) as? PostTableViewCell {
            cell.updateLikesCount(post.likesCount)
        }
        
    }
}


// MARK: - Table view logic
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post) { [weak self] in
            guard let self = self else { return }
            self.likePost(at: indexPath)
        }
        return cell
    }
}
