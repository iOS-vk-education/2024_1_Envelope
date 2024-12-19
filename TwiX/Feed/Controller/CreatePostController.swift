//
//  CreatePostController.swift
//  TwiX
//
//  Created by Alexander on 04.12.2024.
//

import UIKit

final class CreatePostController: UIViewController {
    weak var delegate: CreatePostControllerDelegate?
    
    // MARK: Private properties
    
    private var authorName: String?
    private var authorUsername: String?
    private var authorAvatarURL: URL?
    private let likesCount: Int = 0
    private let commentsCount: Int = 0
    private let timestamp: Date = Date()
    
    private let postManager = PostManager.shared
    private let userSession = UserSessionManager.shared
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: Fonts.Urbanist_Medium, size: 16)
        textView.textColor = .black
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didSaveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Logic starts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAuthorData()
    }
    
    public func loadAuthorData() {
        let userSession = UserSessionManager.shared
        guard let currentUserUID = userSession.currentUser?.uid else {
                print("User not logged in")
                return
        }
        userSession.fetchUserFromDatabase(uid: currentUserUID) { result in
            switch result {
            case .success(let userData):
                if let name = userData["authorName"] as? String,
                   let authorUsername = userData["authorUsername"] as? String,
                   let avatarURLString = userData["authorAvatarURL"] as? String{
                    self.authorName = name
                    self.authorUsername = authorUsername
                    self.authorAvatarURL = URL(string: avatarURLString)
                } else {
                    print("Error: user data is invalid")
                }
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // TextView
            textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didSaveButtonTapped() {
        saveTapped()
    }
    
    // MARK: - Post saving to DB
    
    private func saveTapped() {
        guard let text = textView.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Post cannot be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let authorName = authorName, let authorUsername = authorUsername else {
            let alert = UIAlertController(title: "Error", message: "User information are missing!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        var moods: [Mood] = [.angry, .happy]
        
        if moods.count > 3 {
            moods = Array(moods[..<3])
        }
        
        let post = Post(id: UUID(), text: text, mood: moods, authorName: authorName, authorUsername: authorUsername, authorAvatarURL: authorAvatarURL ?? URL(string: "https://cataas.com/cat")!, likesCount: likesCount, commentsCount: commentsCount, timestamp: timestamp)
        
        postManager.addPost(post)
        delegate?.didCreatePost()
        print("Post saved: \(post)")
        dismiss(animated: true, completion: nil)
    }
}
