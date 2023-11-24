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
    private let viewModel: ChatViewModel
    
    #warning("uicollectionview compositional layout")
    private let chatContentCollectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.register(ChatContentCell.self, forCellWithReuseIdentifier: ChatContentCell.identifier)
        return cv
    }()
    
    
    //MARK: - Lifecycle
    init(viewModel: ChatViewModel) {
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
        
    }
    
    private func bind() {
        bindCollectionView()
    }
    
    private func bindCollectionView() {
        viewModel.setupCollectionView(chatContentCollectionView)
    }
}
