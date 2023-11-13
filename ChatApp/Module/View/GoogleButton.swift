//
//  GoogleButton.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/13/23.
//

import UIKit

class GoogleButton: UIButton {
    //MARK: - properties
    
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - method
    private func configureButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6
        self.backgroundColor = ThemeColor.weakPrimary
        
        if let originalImage = UIImage(named: "google"), let resizedImage = originalImage.resized(to: CGSize(width: 16, height: 16)) {
            self.setImage(resizedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        self.setTitleColor(.white, for: .normal)
        self.setTitle("Sign in with Google", for: .normal)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        
//        if #available(iOS 15.0, *) {
//            var configuration = UIButton.Configuration.plain()
//            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//            configuration.imagePadding = 10
//            var titleContainer = AttributeContainer()
//            titleContainer.font = ThemeFont.demiBold(size: 23)
//            let title = AttributedString("Sign in with Google", attributes: titleContainer)
//            configuration.attributedTitle = title
//            self.configuration = configuration
//        } else {
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        }
    }
}
