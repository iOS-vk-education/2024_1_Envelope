//
//  TabBarController.swift
//  TwiX
//
//  Created by Alexander on 04.12.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }

    private func setupViewControllers() {
        let mainFeedVC = createNavItem(title: "", image: UIImage(named: Strings.Icons.mainFeedTabBarIcon), vc: MainFeedViewController())
        let searchVC = createNavItem(title: "", image: UIImage(named: Strings.Icons.searchTabBarIcon), vc: ProfileController())
        let createVC = createNavItem(title: "", image:  UIImage(named: Strings.Icons.addPostTabBarIcon), vc: CreatePostController())
        self.setViewControllers([mainFeedVC, createVC, searchVC], animated: true)
    }

    private func setupTabBarAppearance() {
        tabBar.backgroundColor = Colors.backgroundColor
        tabBar.tintColor = UIColor(named: "LightPeach")
        tabBar.isTranslucent = false
    }
    
    private func createNavItem(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}
