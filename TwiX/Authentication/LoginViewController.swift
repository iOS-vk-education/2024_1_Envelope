//
//  LoginViewController.swift
//  TwiX
//
//  Created by Alexander on 06.11.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
   
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let customBackButton = UIButton(type: .system)
        customBackButton.setTitle("Back", for: .normal)
        customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customBackButton.backgroundColor = .red
        customBackButton.frame = CGRect(x: 10, y: 40, width: 60, height: 30)
        customBackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customBackButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            customBackButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            customBackButton.widthAnchor.constraint(equalToConstant: 50),
            customBackButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    
        let backButtonItem = UIBarButtonItem(customView: customBackButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        self.view.addSubview(customBackButton)
        
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
