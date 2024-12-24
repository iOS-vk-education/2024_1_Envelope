//
//  Extensions.swift
//  TwiX
//
//  Created by Tsvetkov Alexey on 11/23/24.
//

import UIKit
import SwiftUI

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
    private let segmentedControl = UISegmentedControl(items: [Strings.Profile.posts, Strings.Profile.likes])
    private let feedView = FeedView()
    private var user = UserSessionManager.shared.currentProfile
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAvatarImage()
        setupView()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.addSubview(scrollView)
        view.backgroundColor = Colors.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubviews(subviews: [
            editProfileButton, avatarButton, nameLabel, tagLabel, statusLabel,
            followingLabel, followersLabel, segmentedControl, feedView,
        ])
    }
    
    private func setupEditProfileButton() {
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
        let vc = UIHostingController(rootView: ProfileSetupView(onSuccess: { [weak self] in self?.dismiss(animated: true) }))
        present(vc, animated: true)
    }
    
    private func setupAvatarButton() {
        avatarButton.setImage(UIImage(named: Strings.Icons.avatarIcon), for: .normal)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.layer.cornerRadius = Constants.ProfileController.Dimensions.avatarButtonSize / 2
        
        loadAvatarImage()
    }
    
    private func loadAvatarImage() {
        guard let avatarURL = user?.authorAvatarURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: avatarURL) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
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
        feedView.translatesAutoresizingMaskIntoConstraints = false
        feedView.backgroundColor = .background
    }
    
    private func setupNavBar() {
        navigationItem.title = Strings.App.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never

        let settingsButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: nil)
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
            feedView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.ProfileController.Paddings.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ProfileController.Paddings.trailingAnchor),
            feedView.heightAnchor.constraint(equalToConstant: 800),
            feedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

private extension ProfileController {
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            feedView.loadUserPosts(userId: user!.authorUsername)
        } else {
            self.feedView.loadPosts()
        }
    }
}
