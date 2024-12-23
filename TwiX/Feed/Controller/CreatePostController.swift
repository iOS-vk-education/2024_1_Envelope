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
    
    private var authorName: String = "authorName"
    private var authorUsername: String = "authorUsername"
    private var authorAvatarURL: URL?
    private let likesCount: Int = 0
    private let commentsCount: Int = 0
    private let timestamp: Date = Date()
    
    private let postManager = PostManager.shared
    
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
    }
    
    public func setAuthor(authorUsername: String) {
        // TODO: fetch author metadata from DB by username
        self.authorName = "hello world"
        self.authorUsername = authorUsername
        self.authorAvatarURL = URL(string: "https://cataas.com/cat")!
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
        
        let post = Post(id: UUID(), text: text, authorName: authorName, authorUsername: authorUsername, authorAvatarURL: authorAvatarURL, likesCount: likesCount, commentsCount: commentsCount, timestamp: timestamp)
        
        postManager.addPost(post)
        delegate?.didCreatePost()
        print("Post saved: \(post)")
        dismiss(animated: true, completion: nil)
    }
}
