//
//  LoginViewController.swift
//  TwiX
//
//  Created by Alexander on 06.11.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let customBackButton = UIButton(type: .system)
//        customBackButton.setTitle("Back", for: .normal)
//        customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        customBackButton.backgroundColor = .red
//        customBackButton.frame = CGRect(x: 10, y: 40, width: 60, height: 30)
//        
//    
//        let backButtonItem = UIBarButtonItem(customView: customBackButton)
//        navigationItem.leftBarButtonItem = backButtonItem
//        
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
