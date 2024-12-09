//
//  Extensions.swift
//  TwiX
//
//  Created by Tsvetkov Alexey on 11/23/24.
//

import UIKit

class ProfileController: UIViewController {
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let editProfileButton: UIButton = UIButton()
    private let avatarButton: UIButton = UIButton()
    private let nameLabel: UILabel = UILabel()
    private let tagLabel: UILabel = UILabel()
    private let statusLabel: UILabel = UILabel()
    private let followingLabel: UILabel = UILabel()
    private let followersLabel: UILabel = UILabel()
    let postManager = PostManager.shared
    let segmentedControl = UISegmentedControl(items: [Strings.Profile.posts, Strings.Profile.likes])
    private let tableView = UITableView()
    var posts: [Post] = []
    var likes: [Post] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        setupView()
        setupScrollView()
        setupEditProfileButton()
        setupAvatarButton()
        setupNameLabel()
        setupTagLabel()
        setupStatusLabel()
        setupFollowersFollowingLabel()
        setupTableView()
        setupNavBar()
        setupConstraints()
        setupSegmentedControl()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = Colors.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        fetchPosts()
    }
    
    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubviews(subviews: [
            editProfileButton, avatarButton, nameLabel, tagLabel, statusLabel,
            followingLabel, followersLabel, segmentedControl, tableView,
        ])
    }
    
    private func setupEditProfileButton() {
        editProfileButton.setTitle(Strings.Profile.editProfile, for: .normal)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.layer.cornerRadius = 16
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = Colors.borderColor.cgColor
        editProfileButton.titleLabel?.font = UIFont(name: Fonts.Poppins_SemiBold, size: 14)
        editProfileButton.tintColor = Colors.borderColor
    }
    
    private func setupAvatarButton() {
        avatarButton.setImage(UIImage(named: Strings.Icons.avatarIcon), for: .normal)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.layer.cornerRadius = Constants.ProfileController.Dimensions.avatarButtonSize / 2
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Andrew"
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: Fonts.Poppins_Bold, size: 22)
    }
    
    private func setupTagLabel() {
        tagLabel.textColor = Colors.noteColor
        tagLabel.text = "@asnx9"
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 16)
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "CT ITMO ENJOYER - Mobile UI/UX development; Math analysis monster"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = UIColor.white
        statusLabel.numberOfLines = 2
        statusLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 16)
        statusLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupFollowersFollowingLabel() {
        followersLabel.textColor = Colors.noteColor
        followersLabel.text = Strings.Profile.followers
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 14)
        
        followingLabel.text = Strings.Profile.following
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.textColor = Colors.noteColor
        followingLabel.font = UIFont(name: Fonts.Poppints_Regular, size: 14)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.backgroundColor = Colors.backgroundColor
    }
    
    private func setupNavBar() {
        navigationItem.title = Strings.App.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
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
            // MARK: - scrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // MARK: - contentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // MARK: - editProfileButton constraints
            editProfileButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.ProfileController.Paddings.editProfileTopAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ProfileController.Paddings.trailingAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.editProfileButtonSize * 2),
            editProfileButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.editProfileButtonSize),
            
            // MARK: - avatarButton constraints
            avatarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            avatarButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.ProfileController.Paddings.topAvatarAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize),
            avatarButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize),
            
            // MARK: - nameLabel constraints
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.ProfileController.Paddings.nameLabelTopAnchor),
            
            // MARK: - tagLabel constraints
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.ProfileController.Paddings.topAnchor),
            
            // MARK: - statusLabel constraints
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ProfileController.Paddings.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: Constants.ProfileController.Paddings.topAnchor),
            
            // MARK: - followingLabel constraints
            followingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor * 2),
            followingLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Constants.ProfileController.Paddings.bottomAnchor),
            
            // MARK: - followersLabel constraints
            followersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.followersLabelLeadingAnchor),
            followersLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Constants.ProfileController.Paddings.bottomAnchor),
            
            // MARK: - segmentControl segments
            segmentedControl.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: Constants.ProfileController.Paddings.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ProfileController.Paddings.trailingAnchor),
            
            // MARK: - tableView constraints
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.ProfileController.Paddings.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ProfileController.Paddings.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 800),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        postManager.fetchPosts { posts in
            DispatchQueue.main.async {
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    self.posts = posts
                } else {
                    self.likes = posts.filter { $0.likesCount > 0 }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchPosts() {
        PostManager.shared.fetchPosts { [weak self] fetchedPosts in
            self?.posts = fetchedPosts
            self?.likes = fetchedPosts.filter { $0.likesCount > 0 }
            self?.tableView.reloadData()
        }
    }
}

#Preview{
    UINavigationController(rootViewController: ProfileController())
}
