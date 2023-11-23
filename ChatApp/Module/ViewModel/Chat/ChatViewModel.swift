//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import UIKit
import Combine
import FirebaseAuth

enum Section: CaseIterable {
    case chat
}

class ChatViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    @Published var navTitle: String?
    
    // TableView
    private (set) var chatList = CurrentValueSubject<[Chat], Never>(Chat.mock)
    private var dataSource: UITableViewDiffableDataSource<Section, Chat>!
    private var snapShot: NSDiffableDataSourceSnapshot<Section, Chat>!
    
    
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
        let viewModel = NewChatViewModel()
        let newChatVC = NewChatViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: newChatVC)
        vc.present(nav, animated: true)
    }
}



//MARK: - UITableView
extension ChatViewModel {
    /// UITableViewDiffableDatasource 정의 >>>>
    func setupTableView(_ tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, Chat>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else { return UITableViewCell() }
            
            let model = self?.chatList.value[indexPath.row]
            cell.configure(model)
            return cell
        })
        
        snapShot = NSDiffableDataSourceSnapshot<Section, Chat>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(chatList.value)
        dataSource.apply(snapShot)
    }
    
}

