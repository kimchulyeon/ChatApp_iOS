//
//  ChatViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import CombineDataSources

class ChatViewController: UIViewController {
    //MARK: - properties
    private lazy var logoutButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: nil)
        btn.tapPublisher.sink { [unowned self] _ in viewModel.handleLogout() }.store(in: &cancellables)
        return btn
    }()
    
    private lazy var newChatButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        btn.tapPublisher.sink { [unowned self] _ in viewModel.handleNewChatButton(self) }.store(in: &cancellables)
        return btn
    }()
    
    private let chatTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = ThemeColor.bg
        tv.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        return tv
    }()
    
    private let viewModel: ChatViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        view.backgroundColor = ThemeColor.bg
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = newChatButton
        
        view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges) }
    }
    
    private func bind() {
        bindNavTitle()
        bindTableView()
    }
    
    private func bindNavTitle() {
        viewModel.$navTitle
            .sink { [weak self] title in
                guard let title = title else { return }
                self?.title = title
            }
            .store(in: &cancellables)
    }
    
    private func bindTableView() {
        viewModel.setupTableView(chatTableView)
    }
}
