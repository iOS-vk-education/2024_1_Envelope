//
//  Constants.swift
//  TwiX
//
//  Created by Alexander on 18.11.2024.
//

import SwiftUI

struct Constants {
    struct Header {
        struct Padding {
            static let top: CGFloat = 10
            static let leading: CGFloat = 20
            static let backButtonLeading: CGFloat = 10
        }
        struct FontSizes {
            static let title: CGFloat = 30
        }
    }
    
    struct AuthenticationFlow {
        struct Spacing {
            static let headerTopPadding: CGFloat = 50
            static let labelPadding: CGFloat = 70
            static let buttonsSpacing: CGFloat = 16
            static let dividerSpacing: CGFloat = 15
            static let bottomSpacing: CGFloat = 75
        }
        struct Padding {
            static let horizontal: CGFloat = 30
        }
        struct FontSizes {
            static let title: CGFloat = 40
            static let signUpText: CGFloat = 12
        }
        struct Dimensions {
            static let buttonCornerRadius: CGFloat = 100
        }
    }
    
    struct Login {
        struct Spacing {
            static let headerTopPadding: CGFloat = 40
            static let fieldSpacing: CGFloat = 15
            static let sectionSpacing: CGFloat = 25
            static let bottomSpacing: CGFloat = 35
        }
        struct Padding {
            static let horizontal: CGFloat = 30
        }
        struct FontSizes {
            static let title: CGFloat = 40
            static let fieldLabel: CGFloat = 16
            static let smallText: CGFloat = 14
        }
        struct Dimensions {
            static let buttonHeight: CGFloat = 60
            static let buttonCornerRadius: CGFloat = 100
            static let smallCornerRadius: CGFloat = 10
        }
    }
    
    struct Register {
        struct Spacing {
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
        struct FontSizes {
            static let title: CGFloat = 40
            static let fieldLabel: CGFloat = 16
        }
        struct Padding {
            static let horizontal: CGFloat = 30
        }
        struct Dimensions {
            static let buttonCornerRadius: CGFloat = 100
            static let smallCornerRadius: CGFloat = 10
            static let fieldCornerRadius: CGFloat = 8
            static let buttonHeight: CGFloat = 60
        }
    }
    
    struct Buttons {
        struct Dimensions {
            static let smallButtonSize: CGSize = CGSize(width: 70, height: 60)
            static let iconSize: CGFloat = 25
            static let smallButtonCornerRadius: CGFloat = 6
            static let smallButtonWidth: CGFloat = 70
            static let smallButtonHeight: CGFloat = 60
        }
    }
    
    struct Divider {
        static let height: CGFloat = 20
        static let lineHeight: CGFloat = 1
    }
}
