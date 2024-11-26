//
//  Extensions.swift
//  TwiX
//
//  Created by Tsvetkov Alexey on 11/23/24.
//

import UIKit

class ProfileController: UIViewController {
    
    // MARK: - UI Elements

    private let avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.avatarButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.Icons.avatarIcon), for: .normal)
        button.tintColor = Colors.mainColor
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.settingsButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.Icons.settingsIcon), for: .normal)
        button.tintColor = Colors.mainColor
        return button
    }()
    
    private let addPostButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.addPostButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.iconBackgroundColor
        button.setImage(UIImage(named: Strings.Icons.addPostIcon), for: .normal)
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
        
        twixLabel.text = Strings.App.name
        twixLabel.textColor = Colors.mainColor
        twixLabel.font = UIFont(name: Fonts.Poppins_Bold, size: Constants.FontSizes.title)
        twixLabel.translatesAutoresizingMaskIntoConstraints = false
        return twixLabel
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = Colors.backgroundColor
        view.addSubviews(subviews: [textLabel,
                                    lineView,
                                    avatarButton,
                                    settingsButton,
                                    addPostButton,
                                   ])
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // MARK: - Constraints для textLabel
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingLabelAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.bottomTopAnchor),
            
            // MARK: - Constraints для lineView
            
            lineView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.topLineAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            // MARK: - Constraints для avatarButton
            
            avatarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingAvatarAnchor),
            avatarButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.topAvatarAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize),
            avatarButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.avatarButtonSize),
            
            // MARK: - Constraints для settingsButton
            
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingSettingsAnchor),
            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.bottomTopAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.settingsButtonSize),
            settingsButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.settingsButtonSize),
            
            // MARK: - Constraints для addPostButton
            
            addPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.ProfileController.Paddings.bottomTopAnchor),
            addPostButton.widthAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.addPostButtonSize),
            addPostButton.heightAnchor.constraint(equalToConstant: Constants.ProfileController.Dimensions.addPostButtonSize),
        ])
    }
}

