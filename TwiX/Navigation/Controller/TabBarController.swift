import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    // MARK: - Create Navigation Controller
    
    private func createNav(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)

        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
    
    // MARK: - Setup tab bar and tab bar style
    
    private func setupViewControllers() {
        let mainFeedVC = createNav(title: "", image: UIImage(named: Strings.Icons.mainFeedTabBarIcon), vc: MainFeedViewController())
        let createVC = createNav(title: "", image:  UIImage(named: Strings.Icons.addPostTabBarIcon), vc: CreatePostController())
        let searchVC = createNav(title: "", image: UIImage(named: Strings.Icons.searchTabBarIcon), vc: SearchController())
        self.setViewControllers([mainFeedVC, createVC, searchVC], animated: true)
    }
    
    private func setupTabBarAppearance() {
        tabBar.backgroundColor = Colors.backgroundColor
        tabBar.tintColor = Colors.backgroundColor
        tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
    
}

// MARK: - Tab Bar Controller Delegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navController = viewController as? UINavigationController,
           navController.viewControllers.first is CreatePostController {
            guard let mainFeedNavController = self.viewControllers?.first as? UINavigationController,
                  let mainFeedVC = mainFeedNavController.viewControllers.first as? MainFeedViewController else { return false
            }
            
            let createPostVC = CreatePostController()
            
            createPostVC.delegate = mainFeedVC
            
            tabBarController.present(createPostVC, animated: true)
            return false
        }
        return true
    }
}
