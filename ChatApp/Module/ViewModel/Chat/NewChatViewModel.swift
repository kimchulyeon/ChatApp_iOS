//
//  NewChatViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/23/23.
//

import UIKit
import Combine
import FirebaseAuth

class NewChatViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    // TableView
    private (set) var userList = CurrentValueSubject<[User], Never>(User.mock)
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    private var snapShot: NSDiffableDataSourceSnapshot<Section, User>!
    
    
    //MARK: - lifecycle
    
    //MARK: - method
}


//MARK: - UITableView
extension NewChatViewModel {
    /// UITableViewDiffableDatasource 정의 >>>>
    func setupTableView(_ tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else { return UITableViewCell() }
            
            let model = self?.userList.value[indexPath.row]
            cell.configure(model)
            return cell
        })
        
        snapShot = NSDiffableDataSourceSnapshot<Section, User>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(userList.value)
        dataSource.apply(snapShot)
    }
    
}

