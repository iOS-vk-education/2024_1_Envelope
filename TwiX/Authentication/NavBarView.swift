//
//  NavBarView.swift
//  TwiX
//
//  Created by Alexander on 11.11.2024.
//

import UIKit

class NavBarView: UIView {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    
    var onBackButtonPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .background
        
        titleLabel.text = "TwiX"
        titleLabel.font = UIFont(name: Fonts.Urbanist_Bold, size: 30.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        backButton.setTitle("Назад", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            backButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
    
    @objc private func backButtonPressed() {
        onBackButtonPressed?()
    }
}
