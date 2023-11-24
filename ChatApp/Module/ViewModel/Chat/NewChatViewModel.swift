//
//  NewChatViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/23/23.
//

import UIKit
import Combine
import FirebaseAuth

enum UserListSection: CaseIterable {
    case list
}

class NewChatViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedUser: User?
    
    // TableView
    private lazy var userList = CurrentValueSubject<[User], Never>(User.mock)
    private var userListPublisher: AnyPublisher<[User], Never> { userList.eraseToAnyPublisher() }
    private var dataSource: UITableViewDiffableDataSource<UserListSection, User>!
    private var snapShot: NSDiffableDataSourceSnapshot<UserListSection, User>!
    
    
    //MARK: - lifecycle
    
    //MARK: - method
}


//MARK: - UITableView
extension NewChatViewModel {
    /// UITableViewDiffableDatasource 정의 >>>>
    func setupTableView(_ tableView: UITableView) {
        dataSource = setupUserTableViewDatasource(tableView)
        updateUserTableView(with: userListPublisher)
        
       
    }
    
    private func setupUserTableViewDatasource(_ tableView: UITableView) -> UITableViewDiffableDataSource<UserListSection, User> {
        UITableViewDiffableDataSource<UserListSection, User>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else { return UITableViewCell() }
            
            let model = self?.userList.value[indexPath.row]
            cell.configure(model)
            return cell
        })
    }
    
    private func updateUserTableView(with publisher: AnyPublisher<[User], Never>) {
        publisher
            .sink { [weak self] userList in
                var newSnapShot = NSDiffableDataSourceSnapshot<UserListSection, User>()
                newSnapShot = NSDiffableDataSourceSnapshot<UserListSection, User>()
                newSnapShot.appendSections(UserListSection.allCases)
                newSnapShot.appendItems(userList)
                self?.snapShot = newSnapShot
                guard let snapShot = self?.snapShot else { return }
                self?.dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
            }
            .store(in: &cancellables)
    }
    
}

