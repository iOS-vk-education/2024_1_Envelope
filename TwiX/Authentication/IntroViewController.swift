//
//  IntroViewController.swift
//  TwiX
//
//  Created by Alexander on 05.11.2024.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class IntroViewController: UIViewController {
    
    // Buttons
    @IBOutlet weak var vkLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var guestLoginButton: UIButton!
    @IBOutlet weak var passwordLoginButton: UIButton!
    
    // Labels
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons(buttons: vkLoginButton, googleLoginButton, appleLoginButton, guestLoginButton)
        //        let tap = UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
        //        signUpLabel.addGestureRecognizer(tap)
    }
    
    private func setupButtons(buttons : UIButton...) {
        buttons.forEach({
            let button = $0
            
            // Border
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.init(hex: 0xA6BCDA).cgColor
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            // Text and Icon
            button.tintColor = .text
            let imageName: String
            switch button {
            case vkLoginButton:
                imageName = "vkIcon"
            case googleLoginButton:
                imageName = "googleIcon"
            case appleLoginButton:
                imageName = "appleIcon"
            case guestLoginButton:
                imageName = "guestIcon"
            default:
                imageName = ""
            }
            
            button.setImage(UIImage(named: imageName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.configuration?.imagePadding = 6
        } )
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
