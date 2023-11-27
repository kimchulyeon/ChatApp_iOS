//
//  PlaceholderTextView.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/27/23.
//

import UIKit
import SnapKit

class PlaceholderTextView: UITextView {
    //MARK: - properties
    private let placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = ThemeColor.weakDarkGray
        lb.font = ThemeFont.regular(size: 14)
        return lb
    }()
    
    //MARK: - lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - method
    private func setupUI() {
        backgroundColor = ThemeColor.moreLightGray
        addCornerRadius(radius: 8)
        isScrollEnabled = false
        font = ThemeFont.regular(size: 14)
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func configurePlaceholderText(with isEmpty: Bool) {
        if isEmpty { placeholderLabel.text = "메세지를 입력하세요" }
        else { placeholderLabel.text = "" }
    }
}
