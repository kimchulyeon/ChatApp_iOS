//
//  ChatContentViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/24/23.
//

import UIKit
import SnapKit

class ChatContentViewController: UIViewController {
    //MARK: - properties
    private let viewModel: ChatContentViewModel
    
    private lazy var chatContentCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout())
        cv.backgroundColor = ThemeColor.bg
        cv.register(ChatContentCell.self, forCellWithReuseIdentifier: ChatContentCell.identifier)
        return cv
    }()
    
    
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
        
        setupUI()
        bind()
    }
    
    
    //MARK: - method
    private func setupUI() {
        view.backgroundColor = ThemeColor.bg
        
        view.addSubview(chatContentCollectionView)
        chatContentCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        bindCollectionView()
    }
    
    private func bindCollectionView() {
        viewModel.setupCollectionView(chatContentCollectionView)
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
