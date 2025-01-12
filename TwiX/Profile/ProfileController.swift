import UIKit
import SwiftUI
import FirebaseFirestore

class ProfileController: UIViewController {
    
    // MARK: - Properties
    
    private var username: String
    private var user: UserProfile?
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let editProfileButton: UIButton = UIButton()
    private let avatarButton: UIButton = UIButton()
    private let nameLabel: UILabel = UILabel()
    private let tagLabel: UILabel = UILabel()
    private let statusLabel: UILabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: [Strings.Profile.posts, Strings.Profile.likes])
    private var feedView: FeedView!
    private let postManager = PostManager.shared
    private let userSession = UserSessionManager.shared
    
    // MARK: - Initializers
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(username: UserSessionManager.shared.currentProfile?.authorUsername ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if username == UserSessionManager.shared.currentProfile?.authorUsername {
            setupCurrentUserProfile()
        } else {
            fetchUserProfile()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if username == UserSessionManager.shared.currentProfile?.authorUsername {
            // Show navigation bar for current user's profile
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        } else {
            // Hide navigation bar for other users' profiles
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Ensure the navigation bar is visible for other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupCurrentUserProfile() {
        guard UserSessionManager.shared.isUserLoggedIn else {
            // Uncomment if you want to show a guest profile
            // showGuestProfile()
            return
        }
        
        guard let user = userSession.currentProfile else {
            print("User is not loaded")
            return
        }
        
        self.user = user
        
        feedView = FeedView(query: Firestore.firestore().collection("posts")
            .whereField("authorUsername", isEqualTo: user.authorUsername)
            .order(by: "timestamp", descending: true))

        setupView()
        loadAvatarImage()
    }
    
    private func fetchUserProfile() {
        userSession.searchUserByUsername(username: username) { [weak self] result in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                switch result {
                case .success(let userProfile):
                    self?.user = userProfile
                    
                    // Initialize feedView with the fetched user's posts
                    self?.feedView = FeedView(query: Firestore.firestore().collection("posts")
                        .whereField("authorUsername", isEqualTo: userProfile.authorUsername)
                        .order(by: "timestamp", descending: true))
                    
                    // Set up the view with the fetched user data
                    self?.setupView()
                    
                    // Load the user's avatar image
                    self?.loadAvatarImage()
                    
                case .failure(let error):
                    // Handle the error, e.g., show an alert to the user
                    self?.showErrorAlert(message: error.localizedDescription)
                    print("Error fetching user profile: \(error.localizedDescription)")
                }
            }
        }
    }

//    private func showGuestProfile() {
//        let guestLabel = UILabel()
//        guestLabel.text = "Guest"
//        guestLabel.textColor = .white
//        guestLabel.font = .boldSystemFont(ofSize: 24)
//        guestLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(guestLabel)
//        NSLayoutConstraint.activate([
//            guestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            guestLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
    
    private func setupView() {
        view.addSubview(scrollView)
        view.backgroundColor = Colors.backgroundColor
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupScrollView()
        setupEditProfileButton()
        setupAvatarButton()
        setupNameLabel()
        setupTagLabel()
        setupStatusLabel()
        setupSegmentedControl()
        setupTableView()
        
        // Call setupNavBar only for the current user's profile
        if username == UserSessionManager.shared.currentProfile?.authorUsername {
            setupNavBar()
        }
        
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubviews(subviews: [
            editProfileButton,
            avatarButton,
            nameLabel,
            tagLabel,
            statusLabel,
            segmentedControl,
            feedView
        ])
    }
    
    private func setupEditProfileButton() {
        guard username == UserSessionManager.shared.currentProfile?.authorUsername else {
            editProfileButton.isHidden = true
            return
        }
        editProfileButton.setTitle(Strings.Profile.editProfile, for: .normal)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.layer.cornerRadius = Constants.ProfileController.Dimensions.editProfileButtonCornerRaduis
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = Colors.borderColor.cgColor
        editProfileButton.titleLabel?.font = UIFont(name: Fonts.Poppins_SemiBold, size: 14)
        editProfileButton.tintColor = Colors.borderColor
    }
    
    @objc
    private func editProfileButtonTapped() {
        let vc = UIHostingController(rootView: ProfileSetupView(onSuccess: { [weak self] in
            self?.dismiss(animated: true)
        }))
        present(vc, animated: true)
    }
    
    private func setupAvatarButton() {
        avatarButton.setImage(UIImage(named: Strings.Icons.avatarIcon), for: .normal)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.layer.cornerRadius = Constants.ProfileController.Dimensions.avatarButtonSize / 2
        avatarButton.clipsToBounds = true
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
        loadAvatarImage()
    }
    
    @objc
    private func avatarTapped() {
        // Prevent navigating to the same profile
        // Optionally, you could implement functionality here
    }
    
    private func loadAvatarImage() {
        guard let avatarURL = user?.authorAvatarURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: avatarURL) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                print("Failed to load avatar image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.avatarButton.setImage(image, for: .normal)
            }
        }
        task.resume()
    }
    
    private func setupNameLabel() {
        nameLabel.text = user?.authorName
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: Fonts.Poppins_Bold, size: 22)
    }
    
    private func setupTagLabel() {
        tagLabel.textColor = Colors.noteColor
        if let username = user?.authorUsername {
            tagLabel.text = "@" + username
        }
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.font = UIFont(name: Fonts.Poppins_Regular, size: 16)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = user?.authorBio ?? "No status set"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = UIColor.white
        statusLabel.numberOfLines = 2
        statusLabel.font = UIFont(name: Fonts.Poppins_Regular, size: 16)
        statusLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let username = user?.authorUsername {
                feedView.loadUserPosts(userId: username)
            }
        } else {
            if let uid = UserSessionManager.shared.currentUser?.uid {
                feedView.loadLikedPosts(uid: uid)
            }
        }
    }
    
    private func setupTableView() {
        feedView.translatesAutoresizingMaskIntoConstraints = false
        feedView.backgroundColor = .background
        feedView.setErrorAction { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = Strings.App.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(openSettingsScreen))
        navigationItem.rightBarButtonItem = settingsButton
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = Colors.backgroundColor
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: Colors.mainColor,
            .font: UIFont(name: Fonts.Poppins_Bold, size: 30) ?? UIFont.systemFont(ofSize: 30)
        ]
        
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: Colors.mainColor,
            .font: UIFont(name: Fonts.Poppins_Bold, size: 30) ?? UIFont.systemFont(ofSize: 30)
        ]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // contentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // editProfileButton
            editProfileButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                   constant: Constants.ProfileController.Paddings.editProfileTopAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                        constant: Constants.ProfileController.Paddings.trailingAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.editProfileButtonSize * 2),
            editProfileButton.heightAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.editProfileButtonSize),
            
            avatarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: Constants.ProfileController.Paddings.leadingAnchor),
            avatarButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: Constants.ProfileController.Paddings.topAvatarAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.avatarButtonSize),
            avatarButton.heightAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.avatarButtonSize),
            
            // nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: avatarButton.trailingAnchor,
                                               constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarButton.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            
            // tagLabel
            tagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                          constant: 4),
            tagLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // statusLabel
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor,
                                             constant: 8),
            
            // segmentedControl
            segmentedControl.topAnchor.constraint(equalTo: statusLabel.bottomAnchor,
                                                  constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -16),
            
            // feedView
            feedView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                          constant: 16),
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: 16),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -16),
            feedView.heightAnchor.constraint(equalToConstant: 800),
            feedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Open Settings Screen
    
    @objc func openSettingsScreen() {
        let to = SettingsScreenController()
        to.modalPresentationStyle = .fullScreen
        present(to, animated: true, completion: nil)
    }
    
    // MARK: - Error Handling
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
