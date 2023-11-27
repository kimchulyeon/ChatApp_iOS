//
//  ChatContentViewModel.swift
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

    static let mock: [ChatContent] = [
        ChatContent(content: "채팅 내용 1", date: "2023-10-11"),
        ChatContent(content: "채팅 내용입니다 <<<<<", date: "2023-10-11"),
        ChatContent(content: "안녕하세요.", date: "2023-10-11"),
        ChatContent(content: "스위프트 코딩중 :::: ", date: "2023-10-11"),
        ChatContent(content: "iOS 개발자되기 어렵네", date: "2023-10-11"),
        ChatContent(content: "채팅 내용 1", date: "2023-10-11"),
        ChatContent(content: "채팅 내용입니다 <<<<<", date: "2023-10-11"),
        ChatContent(content: "안녕하세요.", date: "2023-10-11"),
        ChatContent(content: "스위프트 코딩중 :::: ", date: "2023-10-11"),
        ChatContent(content: "iOS 개발자되기 어렵네", date: "2023-10-11"),
        ChatContent(content: "채팅 내용 1", date: "2023-10-11"),
        ChatContent(content: "채팅 내용입니다 <<<<<", date: "2023-10-11"),
        ChatContent(content: "안녕하세요.", date: "2023-10-11"),
        ChatContent(content: "스위프트 코딩중 :::: ", date: "2023-10-11"),
        ChatContent(content: "iOS 개발자되기 어렵네", date: "2023-10-11"),
        ChatContent(content: "iOS 개발자되기 어렵네iOS 개발자되기 어렵네iOS 개발자되기 어렵네iOS 개발자되기 어렵네", date: "2023-10-11"),
    ]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ChatContentViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    private lazy var chatContents = CurrentValueSubject<[ChatContent], Never>(ChatContent.mock)
    private var chatContentsPublisher: AnyPublisher<[ChatContent], Never> { chatContents.eraseToAnyPublisher() }

    private var datasource: UICollectionViewDiffableDataSource<ChatContentSection, ChatContent>!
    private var snapShot: NSDiffableDataSourceSnapshot<ChatContentSection, ChatContent>!



    //MARK: - lifecycle
    init() { }



    //MARK: - method
    func setupCollectionView(_ collectionView: UICollectionView) {
        datasource = setupCollectionViewDatasource(collectionView)
        updateCollectionViewDatasource(with: chatContentsPublisher)
    }

    private func setupCollectionViewDatasource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<ChatContentSection, ChatContent> {
        return UICollectionViewDiffableDataSource<ChatContentSection, ChatContent>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatContentCell.identifier, for: indexPath) as? ChatContentCell else { return UICollectionViewCell() }
            guard let content = self?.chatContents.value[indexPath.item] else { return UICollectionViewCell() }
            cell.configure(model: content)
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
