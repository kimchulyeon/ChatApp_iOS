//
//  ChatContentCell.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/24/23.
//

import UIKit
import SnapKit

enum ChatContentDirection {
    case left
    case right
}

class ChatContentCell: UICollectionViewCell {
    //MARK: - properties
    static let identifier = "chatContentCell"

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chat_logo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0000-00-00"
        lb.font = ThemeFont.regular(size: 9)
        lb.backgroundColor = .clear
        return lb
    }()
    
    private let bubbleContainer: UIView = {
        let v = UIView()
        v.backgroundColor = ThemeColor.lightGray
        return v
    }()
    
    var bubbleRightAnchor: Constraint!
    var bubbleLeftAnchor: Constraint!
    
    var dateLabelRightAnchor: Constraint!
    var dateLabelLeftAnchor: Constraint!
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.font = ThemeFont.regular(size: 14)
        tv.text = "TEST TEST"
        return tv
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
        backgroundColor = .clear
        
        addSubview(profileImageView)
        profileImageView.addCornerRadius(radius: 30 / 2)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalTo(snp.leading).offset(10)
            make.top.equalToSuperview()
        }
        
        addSubview(bubbleContainer)
        bubbleContainer.addCornerRadius(radius: 12)
        bubbleContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
            bubbleLeftAnchor = make.leading.equalTo(profileImageView.snp.trailing).offset(12).constraint
            bubbleLeftAnchor.activate()
        }
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(bubbleContainer.snp.top).offset(3)
            make.leading.equalTo(bubbleContainer.snp.leading).offset(6)
            make.bottom.equalTo(bubbleContainer.snp.bottom).offset(-3)
            make.trailing.equalTo(bubbleContainer.snp.trailing).offset(-6)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            dateLabelLeftAnchor = make.leading.equalTo(bubbleContainer.snp.trailing).offset(12)
                .constraint
            dateLabelLeftAnchor.activate()
        }
    }
    
    func configure(model: ChatContent) {
        dateLabel.text = model.date
        textView.text = model.content
    }
}

