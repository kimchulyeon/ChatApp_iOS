//
//  UserCell.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/23/23.
//

import UIKit
import SnapKit

class UserCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "userCell"
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = ThemeFont.demiBold(size: 16)
        lb.textColor = ThemeColor.text
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
        profileImageView.addCornerRadius(radius: 50 / 2)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(snp.top).offset(3)
            make.bottom.lessThanOrEqualTo(snp.bottom).offset(-3)
            make.leading.equalTo(snp.leading).offset(24)
        }

        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-24)
        }

    }

    
    func configure(_ user: User?) {
        guard let user = user else { return }
        profileImageView.image = UIImage(named: "chat_logo")
        nameLabel.text = user.name
    }
}
