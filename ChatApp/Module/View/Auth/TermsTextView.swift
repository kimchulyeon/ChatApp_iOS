//
//  TermsTextView.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/15/23.
//

import UIKit

class TermsTextView: UITextView {
    //MARK: - properties
    
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
        let text = "회원가입을 하시면 이용약관 및\n개인정보 처리방침에 동의로 간주합니다"
        let termsOfServiceRange = (text as NSString).range(of: "이용약관")
        let privacyPolicyRange = (text as NSString).range(of: "개인정보 처리방침")
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: ThemeFont.regular(size: 15), .foregroundColor: ThemeColor.text])
        attributedString.addAttributes([.link: "termsOfService", .foregroundColor: ThemeColor.primary, .font: ThemeFont.demiBold(size: 15)], range: termsOfServiceRange)
        attributedString.addAttributes([.link: "privacyPolicy", .foregroundColor: ThemeColor.primary, .font: ThemeFont.demiBold(size: 15)], range: privacyPolicyRange)
        
        attributedText = attributedString
        textAlignment = .center
        backgroundColor = ThemeColor.bg
        isEditable = false
        isScrollEnabled = false
    }
}

