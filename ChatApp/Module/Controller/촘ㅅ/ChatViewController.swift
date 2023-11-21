//
//  ChatViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import UIKit

class ChatViewController: UIViewController {
    //MARK: - properties
    private lazy var logoutButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(handleLogout))
        return btn
    }()
    
    private let viewModel: ChatViewModel
    
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
    }
    
    //MARK: - method
    private func setupUI() {
        view.backgroundColor = ThemeColor.bg
        
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func handleLogout() {
        CommonUtil.handleLogout()
    }
}
