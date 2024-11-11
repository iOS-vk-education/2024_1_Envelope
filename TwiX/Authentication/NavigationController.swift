//
//  NavigationController.swift
//  TwiX
//
//  Created by Alexander on 11.11.2024.
//

import UIKit

class NavigationController: UINavigationController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем UILabel
        let twixLabel = UILabel()
        twixLabel.font = UIFont(name: Fonts.Urbanist_Bold, size: 30.0)
        twixLabel.text = "TwiX"
        twixLabel.textColor = .text
        
        // Убираем автоматические констрейнты, так как мы будем использовать frame
        twixLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем метку в навигационную панель
        self.navigationBar.addSubview(twixLabel)
        
        // Ручное позиционирование с использованием frame
        let labelHeight: CGFloat = 30.0  // Устанавливаем высоту метки, которая соответствует шрифту
        let labelWidth: CGFloat = 100.0  // Можно настроить ширину метки в зависимости от текста
        
        twixLabel.frame = CGRect(x: 50, y: (self.navigationBar.frame.height - labelHeight) / 2, width: labelWidth, height: labelHeight)
        
        // Делаем навигационную панель полупрозрачной
        self.navigationBar.isTranslucent = true
    }
    
    
    
}
