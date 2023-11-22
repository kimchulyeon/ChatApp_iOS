//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import UIKit
import Combine
import FirebaseAuth

class ChatViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    @Published var navTitle: String?
    var chatList = PassthroughSubject<[Chat], Never>()
    
    
    //MARK: - lifecycle
    init() {
        bind()
    }
    
    //MARK: - method
    private func bind() {
        bindNavTitle()
    }
    
    private func bindNavTitle() {
        UserDefaultsManager.getSingleData(key: Key.Name)
            .sink { [weak self] data in
                guard let data = data as? String, data.isEmpty == false else { return }
                self?.navTitle = data
            }
            .store(in: &cancellables)
    }
    
    func handleLogout() {
        let loginViewModel = LoginViewModel()
        let navigationController = UINavigationController(rootViewController: LoginViewController(viewModel: loginViewModel))
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("🔴 Error while signing out")
        }
        
        UserDefaultsManager.resetUserDefaults()
        CommonUtil.changeRootView(to: navigationController)
    }
    
    func handleNewChatButton(_ vc: UIViewController) {
        let newChatVC = NewChatViewController()
        let nav = UINavigationController(rootViewController: newChatVC)
        vc.present(nav, animated: true)
    }
}

