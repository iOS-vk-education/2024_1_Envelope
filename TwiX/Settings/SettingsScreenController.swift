//
//  SettingsScreenController.swift
//  TwiX
//
//  Created by Егор Юлин on 23.11.2024.
//

import UIKit

fileprivate func generateImage(imageName: String, width: CGFloat, height: CGFloat) -> UIImageView {
    let image = UIImageView(image: UIImage(named: imageName))
    
    image.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        image.widthAnchor.constraint(equalToConstant: width),
        image.heightAnchor.constraint(equalToConstant: height)
    ])
    
    return image
}

fileprivate func generateText(text: String, font: String, size: CGFloat) -> UILabel {
    let label = UILabel()
    
    label.text = text
    label.textColor = Colors.mainColor
    label.font = UIFont(name: font, size: size)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
}

fileprivate func generateSettingsMenu(iconName: String, text: String, buttonFunc: Selector? = nil, startValue: Bool = true) -> UIView {
    let view = UIView()
    
    let icon: UIImageView = generateImage(imageName: iconName, width: 48, height: 48)
    let label = generateText(text: text, font: Fonts.Poppins_Regular, size: Constants.FontSizes.title)
    
    view.addSubview(label)
    view.addSubview(icon)
    
    NSLayoutConstraint.activate([
        icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        label.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
        icon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 17)
    ])
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    guard let function = buttonFunc else { return view }
    
    let switchController = UISwitch()
    
    switchController.isOn = startValue
    switchController.translatesAutoresizingMaskIntoConstraints = false
    
    switchController.onTintColor = Colors.iconBackgroundColor
    
    view.addSubview(switchController)
    
    NSLayoutConstraint.activate([
        switchController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22),
        switchController.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    switchController.addTarget(nil, action: function, for: .valueChanged)
    
    return view
}

fileprivate func generateLine() -> UIView {
    let line = UIView()
    
    line.backgroundColor = Colors.mainColor
    line.translatesAutoresizingMaskIntoConstraints = false
    
    return line
}

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    
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
    
    private let lineView: UIView = generateLine()
    private let lineView2: UIView = generateLine()
    private let lineView3: UIView = generateLine()
    
    private let textLabel: UILabel = generateText(text: Strings.App.name, font: Fonts.Poppins_Bold, size: Constants.FontSizes.title)
    
    private let languagesView: UIView = generateSettingsMenu(iconName: Strings.Icons.languageIconString, text: Strings.Settings.languageLabel)
    private let notificationsView: UIView = generateSettingsMenu(iconName: Strings.Icons.notificationIconString, text: Strings.Settings.notificationLabel, buttonFunc: #selector(notificationsSwitch(_:)))
    private let themeView: UIView = generateSettingsMenu(iconName: Strings.Icons.themeIconString, text: Strings.Settings.themeLabel, buttonFunc: #selector(themeSwitch(_:)), startValue: false)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        view.backgroundColor = Colors.backgroundColor
        setupTitleLabel()
        setupSettingsButton()
        setupLineView()
        setupLanguageSettings()
        setupLineView2()
        setupNotificationSettings()
        setupLineView3()
        setupThemeSettings()
    }
    
    private func setupTitleLabel() {
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ProfileController.Paddings.leadingLabelAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.ProfileController.Paddings.bottomTopAnchor)
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
    
    private func setupLineView() {
        view.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: view.topAnchor, constant: 146),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupLineView2() {
        view.addSubview(lineView2)
        
        NSLayoutConstraint.activate([
            lineView2.topAnchor.constraint(equalTo: languagesView.bottomAnchor, constant: 16),
            lineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView2.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupLineView3() {
        view.addSubview(lineView3)
        
        NSLayoutConstraint.activate([
            lineView3.topAnchor.constraint(equalTo: notificationsView.bottomAnchor, constant: 16),
            lineView3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView3.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupLanguageSettings() {
        view.addSubview(languagesView)
        
        NSLayoutConstraint.activate([
            languagesView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16),
            languagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            languagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            languagesView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(changeLanguage(_:)))
        longPressGesture.minimumPressDuration = 0
        languagesView.addGestureRecognizer(longPressGesture)
        languagesView.isUserInteractionEnabled = true
    }
    
    private func setupNotificationSettings() {
        view.addSubview(notificationsView)
        
        NSLayoutConstraint.activate([
            notificationsView.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 16),
            notificationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupThemeSettings() {
        view.addSubview(themeView)
        
        NSLayoutConstraint.activate([
            themeView.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 16),
            themeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themeView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func changeLanguage(_ sender: UITapGestureRecognizer) {
        if sender.state != .began { return }
        guard let tappedView = sender.view else { return }
            
        UIView.animate(withDuration: 0.1, animations: {
            tappedView.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                tappedView.alpha = 1.0
            }
        }
        
        print(1)
    }
    
    @objc func notificationsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("Переключатель включен")
        } else {
            print("Переключатель выключен")
        }
    }
    
    @objc func themeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("Переключатель включен")
        } else {
            print("Переключатель выключен")
        }
    }
}

#Preview {
    SettingsViewController()
}
