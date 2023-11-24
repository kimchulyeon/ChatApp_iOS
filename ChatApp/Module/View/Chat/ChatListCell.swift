//
//  ChatListCell.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/22/23.
//

import UIKit
import SnapKit

class ChatListCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "chatListCell"

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

    private let recentMessageLabel: UILabel = {
        let lb = UILabel()
        lb.font = ThemeFont.regular(size: 13)
        lb.textColor = .lightGray
        return lb
    }()

    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, recentMessageLabel])
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .leading
        return sv
    }()

    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = ThemeFont.regular(size: 10)
        lb.textColor = .darkGray
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
            make.top.equalTo(snp.top).offset(8)
            make.bottom.lessThanOrEqualTo(snp.bottom).offset(-8)
            make.leading.equalTo(snp.leading).offset(10)
        }

        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-10)
        }

        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-10)
        }


    }

    func configure(_ data: Chat?) {
        guard let data = data else { return }

        profileImageView.image = UIImage(named: "chat_logo")
        nameLabel.text = data.name
        recentMessageLabel.text = data.lastChat
        dateLabel.text = data.date
    }
}
