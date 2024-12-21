//
//  AlertHelper.swift
//  TwiX
//
//  Created by Alexander on 19.12.2024.
//

import UIKit
import SwiftUI

struct AlertHelper {
    static func showAlert(title: String, message: String) {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        rootVC.present(alert, animated: true, completion: nil)
    }
}
