import UIKit

final class PostDetailViewController: UIViewController {
    private let post: Post

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Poppins_Bold, size: 18)
        label.textColor = Colors.mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Urbanist_Medium, size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Urbanist_Medium, size: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Urbanist_Medium, size: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        button.tintColor = Colors.mainColor
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(hex: "#01172F")
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = UIFont(name: Fonts.Urbanist_Regular, size: 16)
        textView.textColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()
    
    // MARK: - Initializer
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.large()]
            sheetPresentationController?.prefersGrabberVisible = true
        } else {
            modalPresentationStyle = .pageSheet
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupLayout()
        loadData()
        setupAvatarTapGesture()
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        view.addSubview(closeButton)
        view.addSubview(avatarImageView)
        view.addSubview(authorNameLabel)
        view.addSubview(authorUsernameLabel)
        view.addSubview(dateLabel)
        view.addSubview(likesLabel)
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            avatarImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            authorNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            authorUsernameLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 2),
            authorUsernameLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            authorUsernameLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: authorUsernameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: authorUsernameLabel.leadingAnchor),

            likesLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),

            textView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func loadData() {
        textView.text = post.text
        authorNameLabel.text = post.authorName
        authorUsernameLabel.text = "@\(post.authorUsername)"
        dateLabel.text = Post.formatTimestamp(post.timestamp)
        likesLabel.text = "\(post.likesCount) likes"
        
        if let url = post.authorAvatarURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }
            }
        }
    }
    
    private func setupAvatarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func avatarTapped() {
        let profileVC = ProfileController(username: post.authorUsername)
        let navController = UINavigationController(rootViewController: profileVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
