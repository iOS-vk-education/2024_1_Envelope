//
//  Extensions.swift
//  TwiX
//
//  Created by Tsvetkov Alexey on 11/23/24.
//

import UIKit

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Elements

    private let avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.avatarButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.IconNames.avatarIcon), for: .normal)
        button.tintColor = Colors.mainColor
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.settingsButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.IconNames.settingsIcon), for: .normal)
        button.tintColor = Colors.mainColor
        return button
    }()
    
    private let addPostButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.addPostButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.IconNames.addPostIcon), for: .normal)
        button.tintColor = Colors.mainColor
        return button
    }()
    
    private let lineView: UIView = {
        let line = UIView()
        
        line.backgroundColor = Colors.mainColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let textLabel: UILabel = {
        let twixLabel = UILabel()
        
        twixLabel.text = Strings.Headers.appName
        twixLabel.textColor = Colors.mainColor
        twixLabel.font = UIFont(name: Fonts.Poppins_Bold, size: Constants.FontSizes.title)
        twixLabel.translatesAutoresizingMaskIntoConstraints = false
        return twixLabel
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = Colors.backgroundColor
        setupTitleLabel()
        setupLineView()
        setupAvatarButton()
        setupSettingsButton()
        setupAddPostButton()
    }
    
    private func setupTitleLabel() {
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingLabelAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.bottomTopAnchor)
        ])
    }
    
    private func setupAvatarButton() {
        view.addSubview(avatarButton)
        
        NSLayoutConstraint.activate([
            avatarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAvatarAnchor),
            avatarButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.topAvatarAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize),
            avatarButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize)
        ])
    }
    
    private func setupSettingsButton() {
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingSettingsAnchor),
            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.bottomTopAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.settingsButtonSize),
            settingsButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.settingsButtonSize)
        ])
    }
    
    private func setupAddPostButton() {
        view.addSubview(addPostButton)
        
        NSLayoutConstraint.activate([
            addPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.ProfileController.Paddings.bottomTopAnchor),
            addPostButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.addPostButtonSize),
            addPostButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.addPostButtonSize)
        ])
    }
    
    private func setupLineView() {
        view.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

#Preview {
    ProfileController()
}
