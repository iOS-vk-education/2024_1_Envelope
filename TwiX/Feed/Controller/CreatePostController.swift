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
    
    private var selectedMoods: [Mood] = [] {
        didSet {
            updateSelectedMoodsLabel()
        }
    }
    
    private let postManager = PostManager.shared
    private let userSession = UserSessionManager.shared
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: Fonts.Urbanist_Medium, size: 16)
        textView.textColor = .black
        textView.backgroundColor = UIColor(hex: "#01172F")
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = Colors.mainColor
        return textView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        button.tintColor = Colors.mainColor
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didSaveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.backgroundColor = UIColor(hex: "#F65826")
        return button
    }()
    
    private let selectedMoodsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.mainColor
        label.text = "Selected Moods: None"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectedMoodsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.mainColor
        label.text = "Selected Moods: 0/3"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let removeLastMoodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Last Mood", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(removeLastMoodTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hex: "#FF0000")
        return button
    }()
    
    private let moodPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Mood", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showMoodPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hex: "#026873")
        return button
    }()
    
    private lazy var moodPickerView: MoodPickerView = {
        let picker = MoodPickerView()
        picker.delegate = self
        return picker
    }()
    
    // MARK: - Logic starts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAuthorData()
    }
    
    public func loadAuthorData() {
        guard let currentUserUID = userSession.currentUser?.uid else {
            print("User not logged in")
            return
        }
        userSession.fetchUserFromDatabase(uid: currentUserUID) { result in
            switch result {
            case .success(let userData):
                if let name = userData["authorName"] as? String,
                   let authorUsername = userData["authorUsername"] as? String,
                   let avatarURLString = userData["authorAvatarURL"] as? String {
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
        view.backgroundColor = .background
        view.addSubview(textView)
        view.addSubview(moodPickerButton)
        view.addSubview(selectedMoodsLabel)
        view.addSubview(selectedMoodsCountLabel)
        view.addSubview(removeLastMoodButton)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 67),
            saveButton.heightAnchor.constraint(equalToConstant: 34),
            
            // TextView
            textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: selectedMoodsLabel.topAnchor, constant: -16),
            
            // Selected Moods Label
            selectedMoodsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedMoodsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedMoodsLabel.bottomAnchor.constraint(equalTo: selectedMoodsCountLabel.topAnchor, constant: -8),
            
            // Selected Moods Count Label
            selectedMoodsCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedMoodsCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedMoodsCountLabel.bottomAnchor.constraint(equalTo: removeLastMoodButton.topAnchor, constant: -8),
            
            // Remove Last Mood Button
            removeLastMoodButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            removeLastMoodButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            removeLastMoodButton.bottomAnchor.constraint(equalTo: moodPickerButton.topAnchor, constant: -16),
            removeLastMoodButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Mood Picker Button
            moodPickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moodPickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moodPickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            moodPickerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    
    private func updateSelectedMoodsLabel() {
        if selectedMoods.isEmpty {
            selectedMoodsLabel.text = "Selected Moods: None"
        } else {
            let moodsText = selectedMoods.map { $0.rawValue }.joined(separator: " ")
            selectedMoodsLabel.text = "Selected Moods: \(moodsText)"
        }
        selectedMoodsCountLabel.text = "Selected Moods: \(selectedMoods.count)/3"
    }
    
    @objc private func showMoodPicker() {
        moodPickerView.showPicker(from: self, selectedMoods: selectedMoods)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didSaveButtonTapped() {
        saveTapped()
    }
    
    @objc private func removeLastMoodTapped() {
        if !selectedMoods.isEmpty {
            selectedMoods.removeLast()
            updateSelectedMoodsLabel()
        }
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
            let alert = UIAlertController(title: "Error", message: "User information is missing!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let post = Post(id: UUID(), text: text, mood: selectedMoods, authorName: authorName, authorUsername: authorUsername, authorAvatarURL: authorAvatarURL, likesCount: likesCount, commentsCount: commentsCount, timestamp: timestamp)
        
        postManager.addPost(post)
        delegate?.didCreatePost()
        print("Post saved: \(post)")
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostController: MoodPickerViewDelegate {
    func moodPickerView(_ pickerView: MoodPickerView, didSelectMoods moods: [Mood]) {
        self.selectedMoods = moods
        updateSelectedMoodsLabel()
    }
}
