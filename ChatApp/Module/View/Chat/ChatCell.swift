//
//  ChatContentCell.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/24/23.
//

import UIKit
import SnapKit

class ChatContentCell: UICollectionViewCell {
    //MARK: - properties
    static let identifier = "chatContentCell"

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - method
    private func setupUI() {
        addSubview(profileImageView)
        profileImageView.addCornerRadius(radius: 30 / 2)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    func configure() {
        
    }
}

