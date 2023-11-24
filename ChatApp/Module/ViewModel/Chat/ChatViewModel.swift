//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/24/23.
//

import UIKit
import Combine

enum ChatContentSection: CaseIterable {
    case content
}

struct ChatContent: Hashable {
    let id: String = UUID().uuidString
    let content: String
    let date: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ChatViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    private lazy var chatContents = CurrentValueSubject<[ChatContent], Never>([])
    private var chatContentsPublisher: AnyPublisher<[ChatContent], Never> { chatContents.eraseToAnyPublisher() }
    
    private var datasource: UICollectionViewDiffableDataSource<ChatContentSection, ChatContent>!
    private var snapShot: NSDiffableDataSourceSnapshot<ChatContentSection, ChatContent>!
    
    
    
    //MARK: - lifecycle
    init() { }
    
    
    
    //MARK: - method
    
}



//MARK: - CollectionView
extension ChatViewModel {
    
    func setupCollectionView(_ collectionView: UICollectionView) {
        datasource = setupCollectionViewDatasource(collectionView)
        updateCollectionViewDatasource(with: chatContentsPublisher)
    }
    
    private func setupCollectionViewDatasource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<ChatContentSection, ChatContent> {
        UICollectionViewDiffableDataSource<ChatContentSection, ChatContent>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatContentCell.identifier, for: indexPath) as? ChatContentCell else { return UICollectionViewCell() }
            cell.configure()
            return cell
        })
    }
    
    private func updateCollectionViewDatasource(with chatContentsPublisher: AnyPublisher<[ChatContent], Never>) {
        chatContentsPublisher
            .sink { [weak self] chatContents in
                var newSnapShot = NSDiffableDataSourceSnapshot<ChatContentSection, ChatContent>()
                newSnapShot.appendSections(ChatContentSection.allCases)
                newSnapShot.appendItems(chatContents)
                self?.snapShot = newSnapShot
                guard let snapShot = self?.snapShot else { return }
                self?.datasource.apply(snapShot, animatingDifferences: false, completion: nil)
            }
            .store(in: &cancellables)
    }
}
