import UIKit

final class MainFeedViewController: UIViewController, CreatePostControllerDelegate {
    
    private let feedView = FeedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupFeedView()
        setupFeedViewConstraints()
        feedView.navigationController = navigationController
    }
    
    func didCreatePost() {
        feedView.loadPosts()
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
        feedView.setErrorAction() { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
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
    
    func setupNavBar() {
        navigationItem.title = Strings.App.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .background
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: Fonts.Poppins_Bold, size: 30) ?? UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor: UIColor(.text)
        ]
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(profileButtonTapped))
        profileButton.tintColor = Colors.mainColor
        navigationItem.leftBarButtonItem = profileButton
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(openSettingsScreen))
        navigationItem.rightBarButtonItem = settingsButton
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.tintColor = .text
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc
    private func profileButtonTapped() {
        let profileVC = ProfileController(user: UserSessionManager.shared.currentProfile)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    func openSettingsScreen() {
        let settingsVC = SettingsScreenController()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true, completion: nil)
    }
}
