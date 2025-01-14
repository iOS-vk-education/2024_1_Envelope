import UIKit

final class PostView: UIView {
    
    // MARK: - Private properties
    
    private let authorLabel = UILabel()
    private let usernameLabel = UILabel()
    private let timeLabel = UILabel()
    private let avatarImageView = UIButton()
    private let postTextLabel = UILabel()
    private let moodsStackView = UIStackView()
    
    // MARK: - Public properties
    
    var likeButton = UIButton()
    var likesCountLabel = UILabel()
    var likeButtonAction: (() -> Void)?
    var avatarTapAction: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with post: Post, likeAction: @escaping () -> Void, errorAction: @escaping (_ message: String) -> Void) {
        authorLabel.text = post.authorName
        usernameLabel.text = "@\(post.authorUsername)"
        timeLabel.text = "\(Post.formatTimestamp(post.timestamp))"
        postTextLabel.text = post.text
        likesCountLabel.text = "\(post.likesCount)"
        likeButtonAction = likeAction
        [authorLabel, postTextLabel].forEach({$0.textColor = .white})
        PostManager.shared.isPostLiked(post.id) { isLiked in
            print(isLiked)
            if isLiked {
                self.likeButton.tintColor = .red
            } else {
                self.likeButton.tintColor = .gray
            }
        }
        
        moodsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        post.mood.forEach { mood in
            let label = UILabel()
            label.text = mood.rawValue
            label.font = UIFont.systemFont(ofSize: 24)
            label.translatesAutoresizingMaskIntoConstraints = false
            moodsStackView.addArrangedSubview(label)
        }
        
        if let avatarUrl = post.authorAvatarURL {
            let task = URLSession.shared.dataTask(with: avatarUrl) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Avatar loading error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Avatar loading error: No data received.")
                    errorAction("Failed to load data")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.avatarImageView.setImage(image, for: .normal)
                    }
                }
            }
            task.resume()
        }
    }
}

// MARK: - Private functions

private extension PostView {
    func setupUI() {
        setupStyling()
        setupSubviews()
        setupTargets()
        setupConstraints()
    }
    
    func setupStyling() {
        // Avatar styling
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        usernameLabel.textColor = .gray
        
        timeLabel.textColor = .gray
    
        postTextLabel.numberOfLines = 5
    
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        likesCountLabel.textColor = .gray
    }
    
    func setupSubviews() {
        [avatarImageView, authorLabel, usernameLabel, timeLabel, postTextLabel, likeButton, likesCountLabel, moodsStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            if let label = $0 as? UILabel {
                label.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
            } else if let button = $0 as? UIButton {
                button.titleLabel?.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
            }
        }
        
        moodsStackView.axis = .horizontal
        moodsStackView.spacing = 4
        moodsStackView.alignment = .center
        moodsStackView.distribution = .equalSpacing
    }
    
    func setupTargets() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        avatarImageView.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
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
            timeLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            
            // Moods stack view
            moodsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moodsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Post text
            postTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postTextLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            // Like button
            likeButton.leadingAnchor.constraint(equalTo: postTextLabel.leadingAnchor),
            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            
            // Like count
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likesCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            // Bottom constraint
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - private action handlers

private extension PostView {
    @objc
    func likeButtonTapped() {
        likeButtonAction?()
    }
    
    @objc
    func avatarTapped() {
        avatarTapAction?()
    }
}
