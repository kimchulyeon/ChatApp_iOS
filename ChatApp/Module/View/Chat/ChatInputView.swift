//
//  ChatInputView.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/27/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class ChatInputView: UIView {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    private let textInputView = PlaceholderTextView()
    private let dividerView: UIView = {
        let v = UIView()
        v.backgroundColor = ThemeColor.lightGray
        return v
    }()
    
    #warning("버튼들")
    
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
        backgroundColor = .white
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(dividerView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}

