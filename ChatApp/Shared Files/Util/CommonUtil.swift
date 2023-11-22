//
//  CommonUtil.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import UIKit
import Firebase

final class CommonUtil {
    static func changeRootView(to vc: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate {

            if let tabBarController = vc as? UITabBarController {
                sceneDelegate.window?.rootViewController = tabBarController
            } else {
                sceneDelegate.window?.rootViewController = vc
            }

            if let window = sceneDelegate.window {
                UIView.transition(with: window, duration: 0.15, options: .transitionCrossDissolve, animations: { })
            }
        }
    }
}
