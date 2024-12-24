import UIKit

class SettingsScreenController: UIViewController {
    // MARK: - UI Elements
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: Strings.Icons.customBackArrow), for: .normal)
        button.tintColor = Colors.mainColor
        button.addTarget(self, action: #selector(closeSettingsController), for: .touchUpInside)
        return button
    }()
    
    private var teamInfo: UILabel!
    private var titleLabel: UILabel!
    
    private let unloginButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.ProfileController.Dimensions.settingsButtonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = Colors.buttonsBackgroundColor
        button.addTarget(self, action: #selector(unloginButtonController), for: .touchUpInside)
        
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.SettingsController.Dimensions.LogoutSize, weight: .bold)
        
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        view.backgroundColor = Colors.backgroundColor
        
        // MARK: setup header
        teamInfo = generateText(text: Strings.Settings.teamInfo, font: Fonts.Montserrat_Regular, size: Constants.SettingsController.Dimensions.infoFontSize, alignment: .center)
        titleLabel = generateText(text: "TwiX", font: Fonts.Poppins_Bold, size: Constants.SettingsController.Dimensions.titleSize, alignment: .center)
        
        view.addSubview(settingsButton)
        view.addSubview(teamInfo)
        view.addSubview(titleLabel)
        view.addSubview(unloginButton)
        
        setupConstraits()
    }
    
    private func setupConstraits() {
        // MARK: setup settings button
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.SettingsController.Paddings.leadingSettingsAnchor),
            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.SettingsController.Paddings.buttonTopAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: Constants.SettingsController.Dimensions.settingsButtonSize),
            settingsButton.heightAnchor.constraint(equalToConstant: Constants.SettingsController.Dimensions.settingsButtonSize)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.SettingsController.Paddings.titleTopAnchor)
        ])
        
        NSLayoutConstraint.activate([
            teamInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            teamInfo.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.SettingsController.Paddings.teamInfoTopAnchor),
            teamInfo.widthAnchor.constraint(equalToConstant: Constants.SettingsController.Dimensions.teamInfoWidth)
        ])
        
        NSLayoutConstraint.activate([
            unloginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unloginButton.topAnchor.constraint(equalTo: teamInfo.bottomAnchor, constant: Constants.SettingsController.Paddings.unloginButtonTopAnchor),
            unloginButton.widthAnchor.constraint(equalToConstant: Constants.SettingsController.Dimensions.unloginButtonWidth),
            unloginButton.heightAnchor.constraint(equalToConstant: Constants.SettingsController.Dimensions.unloginButtonHeight),
        ])
    }
    
    // MARK: - Supporting functions

    private func generateText(text: String, font: String, size: CGFloat, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = Colors.mainColor
        label.font = UIFont(name: font, size: size)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = alignment
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    @objc func closeSettingsController() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func unloginButtonController() {
        // some code
    }
}
