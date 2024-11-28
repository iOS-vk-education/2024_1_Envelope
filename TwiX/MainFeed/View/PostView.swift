//
//  PostView.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import UIKit

class PostView: UIView {
    private let authorLabel = UILabel()
    private let usernameLabel = UILabel()
    private let timeLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let postTextLabel = UILabel()
    private let likeButton = UIButton()
    private let commentsButton = UIButton()
    private let likesCountLabel = UILabel()
    private let commentsCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Avatar styling
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        // Author styling
        authorLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        
        // Username styling
        usernameLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        usernameLabel.textColor = .gray
        
        // Time styling
        timeLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        timeLabel.textColor = .gray
        
        // Tweet text styling
        postTextLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        postTextLabel.numberOfLines = 0
        
        // Buttons styling
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        
        commentsButton.setImage(UIImage(systemName: "message"), for: .normal)
        commentsButton.tintColor = .gray
        
        // Counts styling
        likesCountLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        likesCountLabel.textColor = .gray
        
        commentsCountLabel.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        commentsCountLabel.textColor = .gray
        
        
        // Add subviews
        [avatarImageView, authorLabel, usernameLabel, timeLabel, postTextLabel, likeButton, commentsButton, likesCountLabel, commentsCountLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            if let label = $0 as? UILabel {
                label.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
            } else if let button = $0 as? UIButton {
                button.titleLabel?.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
            }        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Avatar
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Author
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            
            // Username
            usernameLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            // Time
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            // Tweet text
            postTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postTextLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            
            // Like button
            likeButton.leadingAnchor.constraint(equalTo: postTextLabel.leadingAnchor),
            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            
            // Like count
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likesCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            // Comment button
            commentsButton.leadingAnchor.constraint(equalTo: likesCountLabel.trailingAnchor, constant: 24),
            commentsButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            // Comment count
            commentsCountLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 8),
            commentsCountLabel.centerYAnchor.constraint(equalTo: commentsButton.centerYAnchor),
            
            // Bottom constraint
            commentsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with post: Post) {
        authorLabel.text = post.authorName
        usernameLabel.text = "@\(post.authorUsername)"
        timeLabel.text = "\(post.timestamp)"
        postTextLabel.text = post.text
        likesCountLabel.text = "\(post.likesCount)"
        commentsCountLabel.text = "\(post.commentsCount)"
        
        let task = URLSession.shared.dataTask(with: post.authorAvatarURL) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                }
            }
        }
        task.resume()
    }
}
