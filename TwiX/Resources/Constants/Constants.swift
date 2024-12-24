import SwiftUI

enum Constants {
    enum Header {
        enum Padding {
            static let top: CGFloat = 10
            static let leading: CGFloat = 20
            static let backButtonLeading: CGFloat = 10
        }
        
        enum FontSizes {
            static let title: CGFloat = 30
        }
    }
    
    enum FontSizes {
        static let title: CGFloat = 30
    }
    
    enum AuthenticationFlow {
        enum Spacing {
            static let headerTopPadding: CGFloat = 50
            static let labelPadding: CGFloat = 70
            static let buttonsSpacing: CGFloat = 16
            static let dividerSpacing: CGFloat = 15
            static let bottomSpacing: CGFloat = 75
        }
        
        enum Padding {
            static let horizontal: CGFloat = 30
        }
        
        enum FontSizes {
            static let title: CGFloat = 40
            static let signUpText: CGFloat = 12
        }
        
        enum Dimensions {
            static let buttonCornerRadius: CGFloat = 100
            static let buttonHeight: CGFloat = 60
        }
    }
    
    enum Login {
        enum Spacing {
            static let headerTopPadding: CGFloat = 40
            static let fieldSpacing: CGFloat = 15
            static let sectionSpacing: CGFloat = 25
            static let bottomSpacing: CGFloat = 35
        }
        
        enum Padding {
            static let horizontal: CGFloat = 30
        }
        
        enum FontSizes {
            static let title: CGFloat = 40
            static let fieldLabel: CGFloat = 16
            static let smallText: CGFloat = 14
        }
        
        enum Dimensions {
            static let buttonHeight: CGFloat = 60
            static let buttonCornerRadius: CGFloat = 100
            static let smallCornerRadius: CGFloat = 10
        }
    }
    
    enum Register {
        enum Spacing {
            static let headerTopPadding: CGFloat = 40
            static let titleLeading: CGFloat = 30
            static let fieldLeading: CGFloat = 40
            static let fieldHorizontalPadding: CGFloat = 30
            static let fieldVerticalSpacing: CGFloat = 30
            static let sectionSpacing: CGFloat = 25
            static let fieldSpacing: CGFloat = 15
            static let buttonHorizontalPadding: CGFloat = 30
            static let bottomSpacing: CGFloat = 50
        }
        enum FontSizes {
            static let title: CGFloat = 40
            static let fieldLabel: CGFloat = 16
        }
        enum Padding {
            static let horizontal: CGFloat = 30
        }
        enum Dimensions {
            static let buttonCornerRadius: CGFloat = 100
            static let smallCornerRadius: CGFloat = 10
            static let fieldCornerRadius: CGFloat = 8
            static let buttonHeight: CGFloat = 60
        }
    }
    
    enum Buttons {
        enum Dimensions {
            static let smallButtonSize: CGSize = CGSize(width: 70, height: 60)
            static let iconSize: CGFloat = 25
            static let smallButtonCornerRadius: CGFloat = 6
            static let smallButtonWidth: CGFloat = 70
            static let smallButtonHeight: CGFloat = 60
            static let bigButtonHeight: CGFloat = 60
        }
    }
    
    enum Divider {
        static let height: CGFloat = 20
        static let lineHeight: CGFloat = 1
    }
    
    enum ProfileController {
        enum Dimensions {
            static let avatarButtonSize: CGFloat = 68
            static let settingsButtonSize: CGFloat = 48
            static let editProfileButtonSize: CGFloat = 50
            static let editProfileButtonCornerRaduis: CGFloat = 16
        }
        
        enum Paddings {
            static let leadingAnchor: CGFloat = 20
            static let trailingAnchor: CGFloat = -20
            static let bottomAnchor: CGFloat = 20
            static let topAnchor: CGFloat = 10
            static let topAvatarAnchor: CGFloat = 80
            static let followersLabelLeadingAnchor: CGFloat = 140
            static let nameLabelTopAnchor: CGFloat = 159
            static let editProfileTopAnchor: CGFloat = 115
        }
    }
    
    enum SettingsController {
        enum Dimensions {
            static let infoFontSize: CGFloat = 30
            static let teamInfoWidth: CGFloat = 325
            static let settingsButtonSize: CGFloat = 48
            static let unloginButtonWidth: CGFloat = 237
            static let unloginButtonHeight: CGFloat = 65
            static let LogoutSize: CGFloat = 22
            static let titleSize: CGFloat = 40
        }
        
        enum Paddings {
            static let teamInfoTopAnchor: CGFloat = 16
            static let leadingSettingsAnchor: CGFloat = 20
            static let buttonTopAnchor: CGFloat = 55
            static let titleTopAnchor: CGFloat = 185
            static let unloginButtonTopAnchor: CGFloat = 42
        }
    }
}
