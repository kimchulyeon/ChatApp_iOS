//
//  NewChatViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/22/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class NewChatViewController: UIViewController {
    //MARK: - properties
    private let viewModel: NewChatViewModel
    
    private let userTableView: UITableView = {
        let tv = UITableView()
        tv.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        return tv
    }()
    
    //MARK: - Lifecycle
    init(viewModel: NewChatViewModel) {
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
        title = "검색"
        
        view.addSubview(userTableView)
        userTableView.snp.makeConstraints { make in make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges) }
    }
    
    private func bind() {
        bindTableView()
    }
    
    private func bindTableView() {
        viewModel.setupTableView(userTableView)
    }
}
