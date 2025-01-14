import UIKit
import SwiftUI
import FirebaseFirestore

class ProfileController: UIViewController {
    
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
    private var user: UserProfile?
    
    init(user: UserProfile?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserSessionManager.shared.isUserLoggedIn else {
            let guestLabel = UILabel()
            guestLabel.text = "Guest"
            guestLabel.textColor = .white
            guestLabel.font = .boldSystemFont(ofSize: 24)
            guestLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(guestLabel)
            NSLayoutConstraint.activate([
                guestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                guestLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            return
        }
        
        guard let user = user else {
            print("User is not loaded")
            return
        }
        
        
        feedView = FeedView(query: Firestore.firestore().collection("posts")
            .whereField("authorUsername", isEqualTo: user.authorUsername)
            .order(by: "timestamp", descending: true))

        loadAvatarImage()
        setupView()
    }
    
    // MARK: - Setup Methods
    
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
        setupNavBar()
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
        if user?.authorUsername == UserSessionManager.shared.currentProfile?.authorUsername {
            editProfileButton.setTitle(Strings.Profile.editProfile, for: .normal)
            editProfileButton.translatesAutoresizingMaskIntoConstraints = false
            editProfileButton.layer.cornerRadius = Constants.ProfileController.Dimensions.editProfileButtonCornerRaduis
            editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
            editProfileButton.layer.borderWidth = 1
            editProfileButton.layer.borderColor = Colors.borderColor.cgColor
            editProfileButton.titleLabel?.font = UIFont(name: Fonts.Poppins_SemiBold, size: 14)
            editProfileButton.tintColor = Colors.borderColor
        } else {
            editProfileButton.isHidden = true
        }
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
        loadAvatarImage()
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
        tagLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 16)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = user?.authorBio ?? "No status set" // Отображаем статус из профиля
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = UIColor.white
        statusLabel.numberOfLines = 2
        statusLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 16)
        statusLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.buttonsBackgroundColor], for: .selected)
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
            
            // avatarButton
            avatarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: Constants.ProfileController.Paddings.leadingAnchor),
            avatarButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: Constants.ProfileController.Paddings.topAvatarAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.avatarButtonSize),
            avatarButton.heightAnchor.constraint(equalToConstant:
                Constants.ProfileController.Dimensions.avatarButtonSize),
            
            // nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.ProfileController.Paddings.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: Constants.ProfileController.Paddings.nameLabelTopAnchor),
            
            // tagLabel
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: Constants.ProfileController.Paddings.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                          constant: Constants.ProfileController.Paddings.topAnchor),
            
            // statusLabel
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: Constants.ProfileController.Paddings.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: Constants.ProfileController.Paddings.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor,
                                             constant: Constants.ProfileController.Paddings.topAnchor),
            
            // segmentedControl
            segmentedControl.topAnchor.constraint(equalTo: statusLabel.bottomAnchor,
                                                  constant: Constants.ProfileController.Paddings.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: Constants.ProfileController.Paddings.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: Constants.ProfileController.Paddings.trailingAnchor),
            
            // feedView
            feedView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                          constant: Constants.ProfileController.Paddings.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: Constants.ProfileController.Paddings.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: Constants.ProfileController.Paddings.trailingAnchor),
            feedView.heightAnchor.constraint(equalToConstant: 800),
            feedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: Open settings screen
    
    @objc func openSettingsScreen() {
        let to = SettingsScreenController()
        to.modalPresentationStyle = .fullScreen
        present(to, animated: true, completion: nil)
    }
}
