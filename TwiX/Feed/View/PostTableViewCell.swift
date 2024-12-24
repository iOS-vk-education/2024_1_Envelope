//
//  PostTableViewCell.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let postView = PostView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configure(with post: Post, likeAction: @escaping () -> Void, errorAction: @escaping (String) -> Void) {
        postView.configure(with: post, likeAction: likeAction, errorAction: errorAction)
    }
    
    func updateLikesCount(_ count: Int, _ isLiked: Bool) {
        postView.likesCountLabel.text = "\(count)"
        
        if isLiked {
            postView.likeButton.tintColor = .red
        } else {
            postView.likeButton.tintColor = .gray
        }
    }
    
    func changeEnable(_ isEnable: Bool) {
        postView.likeButton.isEnabled = isEnable
    }
}

// MARK: - Private functions

private extension PostTableViewCell {
    func commonInit() {
        setup()
        layout()
    }
    
    func setup() {
        contentView.addSubview(postView)
    }
    
    func layout() {
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
