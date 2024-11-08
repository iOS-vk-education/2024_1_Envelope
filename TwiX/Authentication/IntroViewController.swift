//
//  IntroViewController.swift
//  TwiX
//
//  Created by Alexander on 05.11.2024.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var guestLoginButton: UIButton!
    @IBOutlet weak var passwordLoginButton: UIButton!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let tap = UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
        //        signUpLabel.addGestureRecognizer(tap)
    }
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if segue.identifier == "showLoginSegue" {
//            guard let viewController : LoginViewController = segue.destination as? LoginViewController else { return }
//            
//        }
//    }
}
