//
//  ChatContentViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/24/23.
//

import UIKit
import SnapKit
import Combine

class ChatContentViewController: UIViewController {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ChatContentViewModel
    
    private lazy var chatContentCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout())
        cv.backgroundColor = ThemeColor.bg
        cv.register(ChatContentCell.self, forCellWithReuseIdentifier: ChatContentCell.identifier)
        return cv
    }()
    
    private let chatInputView = ChatInputView()
    
    private var chatInputViewBottomConstraint: Constraint!
    
    
    //MARK: - Lifecycle
    init(viewModel: ChatContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationCenter()
        setupUI()
        bind()
    }
    
    
    //MARK: - method
    private func setupNotificationCenter() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                
                self?.chatInputViewBottomConstraint.update(offset: -keyboardHeight)
                UIView.animate(withDuration: duration) {
                    self?.view.layoutIfNeeded()
                }
                
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                self?.chatInputViewBottomConstraint?.update(offset: 0)

                 UIView.animate(withDuration: duration) {
                     self?.view.layoutIfNeeded()
                 }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeColor.bg
        
        view.addSubview(chatContentCollectionView)
        view.addSubview(chatInputView)
        
        chatContentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(chatInputView.snp.top)
        }
        
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            chatInputViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
            chatInputViewBottomConstraint.activate()
        }
    }
    
    private func bind() {
        bindCollectionView()
    }
    
    private func bindCollectionView() {
        viewModel.setupCollectionView(chatContentCollectionView)
        
        chatContentCollectionView.didSelectItemPublisher
            .sink { [unowned self] _ in
                view.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let width = window.screen.bounds.width
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: width, height: 80)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return layout
    }
}
