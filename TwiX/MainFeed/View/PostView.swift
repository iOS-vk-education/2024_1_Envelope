//
//  PostView.swift
//  TwiX
//
//  Created by Alexander on 28.11.2024.
//

import UIKit

class PostView: UIView {
    private let authorLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let tweetTextLabel = UILabel()
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
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.font = .boldSystemFont(ofSize: 14)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tweetTextLabel.numberOfLines = 0
        tweetTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitleColor(.blue, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        commentsButton.setTitle("Comment", for: .normal)
        commentsButton.setTitleColor(.blue, for: .normal)
        commentsButton.translatesAutoresizingMaskIntoConstraints = false
        
        likesCountLabel.font = .systemFont(ofSize: 12)
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        commentsCountLabel.font = .systemFont(ofSize: 12)
        commentsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, likesCountLabel, commentsButton, commentsCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarImageView)
        addSubview(authorLabel)
        addSubview(tweetTextLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            
            tweetTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            tweetTextLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            tweetTextLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: tweetTextLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: tweetTextLabel.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with post: Post) {
        authorLabel.text = post.authorName
        tweetTextLabel.text = post.text
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
