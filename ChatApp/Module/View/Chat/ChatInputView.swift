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
    
    #warning("버튼들")
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - method
    private func setupUI() {
        backgroundColor = .white
        addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func bind() {
        bindTextInputView()
    }
    
    private func bindTextInputView() {
        textInputView.textPublisher
            .sink { [unowned self] text in
                guard let text = text else { return }
                textInputView.configurePlaceholderText(with: text.isEmpty)
            }
            .store(in: &cancellables)
    }
}

