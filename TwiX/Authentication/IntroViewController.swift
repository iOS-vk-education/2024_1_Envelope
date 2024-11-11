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

struct Divider {
    let view: UIView = UIView()
    init(text: String = "or", lineColor: UIColor = .lightGray, lineHeight: CGFloat = 1.0, fontSize: CGFloat = 16.0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leftLine = UIView()
        leftLine.backgroundColor = lineColor
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftLine)
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = lineColor
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        let rightLine = UIView()
        rightLine.backgroundColor = lineColor
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightLine)
        
        NSLayoutConstraint.activate([
            leftLine.heightAnchor.constraint(equalToConstant: lineHeight),
            leftLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: -8),
            
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rightLine.heightAnchor.constraint(equalToConstant: lineHeight),
            rightLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8),
            rightLine.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addToView(
        _ parentView: UIView,
        leftAnchor: NSLayoutXAxisAnchor,
        rightAnchor: NSLayoutXAxisAnchor,
        topAnchor: NSLayoutYAxisAnchor,
        bottomAnchor: NSLayoutYAxisAnchor,
        leftPadding: CGFloat = 0,
        rightPadding: CGFloat = 0,
        topPadding: CGFloat = 0,
        bottomPadding: CGFloat = 0
    ) {
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leftAnchor, constant: leftPadding),
            view.trailingAnchor.constraint(equalTo: rightAnchor, constant: -rightPadding),
            view.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
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
        [vkLoginButton, googleLoginButton, appleLoginButton, guestLoginButton, passwordLoginButton].forEach({$0?.translatesAutoresizingMaskIntoConstraints = false})
        setupButtons(buttons: vkLoginButton, googleLoginButton, appleLoginButton, guestLoginButton)
        
        // Adding custom divider
        let divider = Divider(text: "or", lineColor: .hintedText, lineHeight: 1.0, fontSize: 16.0)
        divider.addToView(view, leftAnchor: view.safeAreaLayoutGuide.leadingAnchor, rightAnchor: view.safeAreaLayoutGuide.trailingAnchor, topAnchor: guestLoginButton.bottomAnchor, bottomAnchor: passwordLoginButton.topAnchor, leftPadding: 30, rightPadding: 30, topPadding: 20, bottomPadding: 20)
        
        
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
