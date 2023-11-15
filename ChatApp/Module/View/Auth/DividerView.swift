//
//  DividerView.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/13/23.
//

import UIKit

class DividerView: UIView {
    //MARK: - properties
    private let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = ThemeColor.lightGray
        return v
    }()
    private let orLabel: UILabel = {
        let lb = UILabel()
        lb.text = "OR"
        lb.backgroundColor = ThemeColor.bg
        lb.font = ThemeFont.demiBold(size: 13)
        return lb
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
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        addSubview(orLabel)
        orLabel.snp.makeConstraints { make in
            make.centerX.equalTo(lineView.snp.centerX)
            make.centerY.equalTo(lineView.snp.centerY)
        }
    }
}
