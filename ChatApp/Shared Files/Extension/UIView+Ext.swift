//
//  UIView+Ext.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit

extension UIView {
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
