//
//  PostTableViewCell.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    static let identifier = "TweetTableViewCell"
    private let postView = PostView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post, likeAction: @escaping () -> Void) {
        postView.configure(with: post, likeAction: likeAction)
    }
    
    func updateLikesCount(_ count: Int) {
        postView.likesCountLabel.text = "\(count)"
    }
}
