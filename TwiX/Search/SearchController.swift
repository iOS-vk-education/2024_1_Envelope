import UIKit
import FirebaseFirestore

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.App.name
        label.textColor = Colors.mainColor
        label.font = UIFont(name: Fonts.Poppins_Bold, size: Constants.Header.FontSizes.title)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchPlaceholder: UITextField = {
        let placeholder = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeholder.frame.height))
        placeholder.leftView = paddingView
        placeholder.leftViewMode = .always
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeholder.frame.height))
        placeholder.rightView = rightPaddingView
        placeholder.rightViewMode = .always
        let placeholderText = "Enter username"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.borderColor
        ]
        placeholder.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.textColor = Colors.borderColor
        placeholder.layer.borderColor = Colors.borderColor.cgColor
        placeholder.layer.borderWidth = 2.0
        return placeholder
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.SearchController.Dimensions.searchButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.buttonsBackgroundColor
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = Colors.mainColor
        button.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        return button
    }()
    
    private let usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    
    private var users: [String] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        view.backgroundColor = Colors.backgroundColor
        usersTableView.backgroundColor = Colors.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(searchButton)
        view.addSubview(searchPlaceholder)
        view.addSubview(usersTableView)
        setupConstraints()
    }
    
    private func setupTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.SearchController.Paddings.titleTopAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchPlaceholder.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.SearchController.Paddings.commonPadding),
            searchPlaceholder.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.SearchController.Paddings.searchTopAnchor),
            searchPlaceholder.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(Constants.SearchController.Paddings.commonPadding + Constants.SearchController.Dimensions.searchButtonSize + Constants.SearchController.Paddings.commonPadding / 2)),
            searchPlaceholder.heightAnchor.constraint(equalToConstant: Constants.SearchController.Dimensions.searchButtonSize)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.SearchController.Paddings.commonPadding),
            searchButton.topAnchor.constraint(equalTo: searchPlaceholder.topAnchor),
            searchButton.leftAnchor.constraint(equalTo: searchPlaceholder.rightAnchor, constant: Constants.SearchController.Paddings.commonPadding / 2),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.SearchController.Dimensions.searchButtonSize)
        ])
        
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: searchPlaceholder.bottomAnchor, constant: Constants.SearchController.Paddings.userViewTopAnchor),
            usersTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            usersTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        let username = users[indexPath.row]
        cell.configure(with: username)
        return cell
    }
    
    // MARK: - Supporting Functions
    
    @objc func performSearch() {
        guard let searchText = searchPlaceholder.text, !searchText.isEmpty else {
            return
        }
        
        users.removeAll()
        
        let db = Firestore.firestore()
        let users = db.collection("usersHash").document("0_\(searchText)")
        
        users.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                if let uuids = document.get("uuid") as? [String] {
                    for uuid in uuids {
                        self.addUserToFeed(username: uuid)
                    }
                } else {
                    print("No 'usernames' field in the document.")
                }
                
                self.updateFeed()
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    private func addUserToFeed(username: String) {
        users.append(username)
    }
    
    private func updateFeed() {
        usersTableView.reloadData()
    }
}

class UserTableViewCell: UITableViewCell {
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.SearchController.Dimensions.avatarSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.Montserrat_Regular, size: Constants.SearchController.Dimensions.avatarFontSize)
        label.textColor = Colors.mainColor
    
        return label
    }()
    
    private let userUsernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.Montserrat_Regular, size: Constants.SearchController.Dimensions.avatarFontSize)
        label.textColor = Colors.noteColor
    
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userUsernameLabel)
        setupConstraints()
        
        contentView.backgroundColor = Colors.backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.SearchController.Paddings.commonPadding),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: Constants.SearchController.Dimensions.avatarSize),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.SearchController.Dimensions.avatarSize),

            userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: Constants.SearchController.Paddings.commonPadding),
            userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            userUsernameLabel.leftAnchor.constraint(equalTo: userNameLabel.rightAnchor, constant: Constants.SearchController.Paddings.commonPadding),
            userUsernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: Constants.SearchController.Dimensions.cellHeight)
        ])
    }

    func configure(with uuid: String) {
        let db = Firestore.firestore()
        let users = db.collection("users").document(uuid)
        
        var imageUrl: String = ""
        var avatarName: String = ""
        var avatartUsername: String = ""
        
        users.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let authorName = document.get("authorName") as? String {
                    avatarName = authorName
                } else {
                    print("Field 'authorName' does not exist")
                }
                
                if let authorUrl = document.get("authorAvatarURL") as? String {
                    imageUrl = authorUrl
                } else {
                    print("Field 'authorAvatarURL' does not exist")
                }
                
                if let authorUsername = document.get("authorUsername") as? String {
                    avatartUsername = authorUsername
                } else {
                    print("Field 'authorUsername' does not exist")
                }
                
                self.userNameLabel.text = avatarName
                self.userUsernameLabel.text = "@\(avatartUsername)"
                
                if imageUrl.isEmpty {
                    self.userImageView.image = UIImage(named: Strings.Icons.guestIconString)
                } else {
                    if let url = URL(string: imageUrl) {
                        DispatchQueue.global().async {
                            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.userImageView.image = image
                                }
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
