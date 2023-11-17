//
//  UIView+Ext.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import SwiftMessages

extension UIView {
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func showAlert(layout: MessageView.Layout = .cardView,
                   theme: Theme = .error,
                   title: String = "Error",
                   content: String = "",
                   icon: EmojisType = .error,
                   style: SwiftMessages.PresentationStyle = .top,
                   duration: TimeInterval = 2,
                   dimMode: Bool = false,
                   buttonHidden: Bool = true,
                   buttonHandler: ((UIButton) -> Void)? = nil) {
        
        let alertView = MessageView.viewFromNib(layout: layout)
        alertView.configureTheme(theme)
        alertView.configureDropShadow()
        alertView.configureContent(title: title, body: content, iconText: icon.emoji)
        alertView.button?.setTitle("확인", for: .normal)
        alertView.button?.backgroundColor = ThemeColor.primary
        alertView.button?.isHidden = buttonHidden
        alertView.button?.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        alertView.buttonTapHandler = buttonHandler
        alertView.layoutMarginAdditions = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        (alertView.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.Config()
        config.presentationStyle = style
        config.prefersStatusBarHidden = true
        config.duration = .seconds(seconds: duration)
        config.interactiveHide = true
        config.dimMode = dimMode ? .gray(interactive: false) : .none
        
        SwiftMessages.show(config: config, view: alertView)
    }
}
