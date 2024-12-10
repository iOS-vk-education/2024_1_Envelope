//
//  MainFeedViewController.swift
//  TwiX
//
//  Created by Alexander on 02.12.2024.
//

import UIKit

class MainFeedViewController : UIViewController, CreatePostControllerDelegate {
    
    private let feedView = FeedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        setupFeedView()
        setupFeedViewConstraints()
    }
}

// MARK: - Private functions

private extension MainFeedViewController {
    
    func didCreatePost() {
        feedView.loadPosts()
    }
    
    private func setupFeedView() {
        view.addSubview(feedView)
    }
    
    func setupFeedView() {
        feedView.backgroundColor = .background
    }
    
    
    func setupFeedViewConstraints() {
        feedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func openProfileScreen() {
        let profileVC = ProfileController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func setupNavBar() {
        navigationItem.title = Strings.App.name
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        
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
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.leftBarButtonItem = profileButton
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: Strings.Icons.settingsIcon), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.image = UIImage(named: Strings.Icons.backArrow)
        backButton.tintColor = Colors.mainColor
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    @objc
    func profileButtonTapped() {
        openProfileScreen()
    }
    
    
    private func openProfileScreen() {
        let profileVC = ProfileController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
