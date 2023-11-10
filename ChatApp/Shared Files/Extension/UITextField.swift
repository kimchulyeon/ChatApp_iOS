//
//  UITextField.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit

extension UITextField {
    func setPlaceholder(text: String, color: UIColor = ThemeColor.text) {
        let placeholder = NSAttributedString(string: text, attributes: [.foregroundColor: color])
        attributedPlaceholder = placeholder
    }
}
