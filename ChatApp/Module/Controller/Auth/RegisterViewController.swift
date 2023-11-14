//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    //MARK: - properties
    private lazy var termsLabel: UILabel = {
        let lb = UILabel()
        let text = "회원가입을 하시면 이용약관 및\n개인정보 처리방침에 동의로 간주합니다"
        let termsOfServiceRange = (text as NSString).range(of: "이용약관")
        let privacyPolicyRange = (text as NSString).range(of: "개인정보 처리방침")
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: ThemeFont.regular(size: 13), .foregroundColor: ThemeColor.text])
        attributedString.addAttributes([.foregroundColor: ThemeColor.primary, .font: ThemeFont.demiBold(size: 13)], range: termsOfServiceRange)
        attributedString.addAttributes([.foregroundColor: ThemeColor.primary, .font: ThemeFont.demiBold(size: 13)], range: privacyPolicyRange)
        
        lb.attributedText = attributedString
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        lb.numberOfLines = 0
        return lb
    }()



    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    //MARK: - method
    private func setupUI() {
        view.backgroundColor = ThemeColor.bg

        view.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(16)
        }
    }
}
