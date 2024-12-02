//
//  MainFeedViewController.swift
//  TwiX
//
//  Created by Alexander on 02.12.2024.
//

import UIKit

class MainFeedViewController : UIViewController {
    
    private let feedView = FeedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupFeedView()
    }
    
    private func setupFeedView() {
        view.addSubview(feedView)
        
        feedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.topAnchor),
            feedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavBar() {
        navigationItem.title = Strings.App.name
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = profileButton

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
        
    }
}
