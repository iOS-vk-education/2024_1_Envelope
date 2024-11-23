//
//  Constants.swift
//  TwiX
//
//  Created by Alexander on 18.11.2024.
//

import SwiftUI

enum Constants {
    enum FontSizes {
        static let title: CGFloat = 30
    }
    
    enum Header {
        enum Paddings {
            static let top: CGFloat = 10
            static let leading: CGFloat = 20
            static let backButtonLeading: CGFloat = 10
        }
    }
    
    enum AuthenticationFlow {
        enum Spacing {
            static let headerTopPadding: CGFloat = 50
            static let labelPadding: CGFloat = 70
            static let buttonsSpacing: CGFloat = 16
            static let dividerSpacing: CGFloat = 15
            static let bottomSpacing: CGFloat = 75
        }
        
        enum Paddings {
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
        
        enum Paddings {
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
        
        enum Paddings {
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
        enum Colors {
            static let mainColor: UIColor = UIColor(hex: "#EAD8B1")
            static let backgroundColor: UIColor = UIColor(hex: "#001F3F")
            static let iconBackgroundColor: UIColor = UIColor(hex: "#7E60BF")
        }
        
        enum Dimensions {
            static let avatarButtonSize: CGFloat = 123
            static let settingsButtonSize: CGFloat = 48
            static let addPostButtonSize: CGFloat = 80
        }
        
        enum Paddings {
            static let bottomTopAnchor: CGFloat = 55
            static let topAvatarAnchor: CGFloat = 88
            static let leadingSettingsAnchor: CGFloat = 325
            static let leadingAvatarAnchor: CGFloat = 135
            static let leadingLabelAnchor: CGFloat = 25
        }
    }
}
