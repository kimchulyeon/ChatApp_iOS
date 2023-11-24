//
//  ChatListViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/21/23.
//

import UIKit
import Combine
import FirebaseAuth

enum ChatListSection: CaseIterable {
    case chat
}

class ChatListViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    @Published var navTitle: String?
    
    // TableView
    private lazy var chatList = CurrentValueSubject<[Chat], Never>(Chat.mock)
    private var chatListPublisher: AnyPublisher<[Chat], Never> { chatList.eraseToAnyPublisher() }
    private var dataSource: UITableViewDiffableDataSource<ChatListSection, Chat>!
    private var snapShot: NSDiffableDataSourceSnapshot<ChatListSection, Chat>!
    
    
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
extension ChatListViewModel {
    /// UITableViewDiffableDatasource 정의 >>>>
    func setupChatTableView(_ tableView: UITableView) {
        dataSource = setupChatTableViewDatasource(tableView)
        updateChatTableViewDatasource(with: chatListPublisher)
    }
    
    private func setupChatTableViewDatasource(_ tableView: UITableView) -> UITableViewDiffableDataSource<ChatListSection, Chat> {
        UITableViewDiffableDataSource<ChatListSection, Chat>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as? ChatListCell else { return UITableViewCell() }
            let model = self?.chatList.value[indexPath.row]
            cell.configure(model)
            return cell
        })
    }
    
    private func updateChatTableViewDatasource(with publisher: AnyPublisher<[Chat], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatList in
                var newSnapShot = NSDiffableDataSourceSnapshot<ChatListSection, Chat>()
                newSnapShot.appendSections(ChatListSection.allCases)
                newSnapShot.appendItems(chatList)
                self?.snapShot = newSnapShot
                guard let snapShot = self?.snapShot else { return }
                self?.dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
            }
            .store(in: &cancellables)
    }
    
    func addChat(_ chat: Chat) {
        #warning("파라미터로 User ViewModel을 받기")
        #warning("User ViewModel 에서 선택한 유저 데이터를 구독해서 chatList에 send")
        print("ADD >>>> ")
        chatList.send(chatList.value + [chat])
    }
}

