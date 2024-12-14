//
//  MainFeedViewController.swift
//  TwiX
//
//  Created by Alexander on 02.12.2024.
//

import UIKit

final class MainFeedViewController : UIViewController {
    
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
    
    func setupView() {
        view.backgroundColor = .background
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
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: Fonts.Poppins_Bold, size: 30) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor(.text)
        ]
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.leftBarButtonItem = profileButton
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettingsScreen))
        navigationItem.rightBarButtonItem = settingsButton
        
    }
    
    @objc
    func profileButtonTapped() {
        openProfileScreen()
    }
    
    @objc func openSettingsScreen() {
        let to = SettingsScreenController()
        to.modalPresentationStyle = .fullScreen
        present(to, animated: true, completion: nil)
    }
}
