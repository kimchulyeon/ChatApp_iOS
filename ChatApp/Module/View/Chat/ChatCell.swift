//
//  ChatCell.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/22/23.
//

import UIKit
import SnapKit

class ChatCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "chatCell"
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    private let recentMessageLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = ThemeColor.lightGray
        return lb
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = ThemeColor.lightGray
        return lb
    }()
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - method
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.height.width.equalTo(60)
        }
        profileImageView.addCornerRadius(radius: 60 / 2)
    }
    
}
