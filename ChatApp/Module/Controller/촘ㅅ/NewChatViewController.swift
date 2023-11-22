//
//  NewChatViewController.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/22/23.
//

import UIKit

class NewChatViewController: UIViewController {
    //MARK: - properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - method
    private func setupUI() {
        view.backgroundColor = ThemeColor.bg
        title = "검색"
    }
}
