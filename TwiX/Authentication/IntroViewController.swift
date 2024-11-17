//
//  IntroViewController.swift
//  TwiX
//
//  Created by Alexander on 05.11.2024.
//

import UIKit

class IntroViewController: UIViewController {
    
    // MARK: - Buttons
    @IBOutlet weak var vkLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var guestLoginButton: UIButton!
    @IBOutlet weak var passwordLoginButton: UIButton!
    
    // MARK: - Labels
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var twixLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [vkLoginButton, googleLoginButton, appleLoginButton, guestLoginButton, passwordLoginButton].forEach({$0?.translatesAutoresizingMaskIntoConstraints = false})
        setupButtons(buttons: vkLoginButton, googleLoginButton, appleLoginButton, guestLoginButton)
        
        // MARK: - Adding custom divider
        let divider = Divider(text: "or", lineColor: .hintedText, lineHeight: 1.0, fontSize: 16.0)
        divider.addToView(view,
                          leftAnchor: view.safeAreaLayoutGuide.leadingAnchor, rightAnchor: view.safeAreaLayoutGuide.trailingAnchor, topAnchor: guestLoginButton.bottomAnchor, bottomAnchor: passwordLoginButton.topAnchor, leftPadding: 30, rightPadding: 30, topPadding: 20, bottomPadding: 25)
        
        setupButtonLabel(button: passwordLoginButton, color: .white, title: "Sign up with password", size: 16.0)
        setupLabels()
        //        let tap = UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
        //        signUpLabel.addGestureRecognizer(tap)
    }
    
    private func setupLabels() {
        startLabel.font = UIFont(name: Fonts.Urbanist_Bold, size: 40.0)
        twixLabel.font = UIFont(name: Fonts.Urbanist_Bold, size: 30.0)
        
        let fullText = "Dont have an account? Sign up"
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.Urbanist_Regular, size: 14)!,
            .foregroundColor: UIColor.textFieldsDarker
        ]
        
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.Urbanist_Regular, size: 14)!,
            .foregroundColor: UIColor.orangeButton
        ]
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 21))
        attributedString.addAttributes(secondAttributes, range: NSRange(location: 22, length: 7))
        signUpLabel.attributedText = attributedString
        signUpLabel.textAlignment = .center
        
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped(_:))))
    }
    
    @objc private func signUpLabelTapped(_ gesture: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "showLoginSegue", sender: self)
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        super.prepare(for: segue, sender: sender)
    //        if segue.identifier == "SignUpSegue" {
    //
    //        }
    //    }
    
    private func setupButtons(buttons : UIButton...) {
        buttons.forEach({
            let button = $0
            
            // Border
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.init(.textFieldsBorders).cgColor
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            
            // MARK: - Text and Icon
            button.tintColor = .text
            let imageName: String
            var title = "Continue with "
            switch button {
            case vkLoginButton:
                imageName = Strings.Icons.vkIconString
                title += "VK ID"
            case googleLoginButton:
                imageName = Strings.Icons.googleIconString
                title += "Google"
            case appleLoginButton:
                imageName = Strings.Icons.appleIconString
                title += "Apple"
            case guestLoginButton:
                imageName = Strings.Icons.guestIconString
                title = "Continue as Guest"
            default:
                imageName = ""
            }
            setupButtonLabel(button: button, color: .text, title: title, size: 16)
            button.setImage(UIImage(named: imageName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.configuration?.imagePadding = 6
        } )
    }
    
    private func setupButtonLabel(button : UIButton, color : UIColor, title : String, size : CGFloat) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.Urbanist_Medium, size: size)!,
            .foregroundColor: color
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func tapFunction(sender:UITapGestureRecognizer) {
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

private struct Divider {
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
            leftLine.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: -6),
            
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rightLine.heightAnchor.constraint(equalToConstant: lineHeight),
            rightLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 6),
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
