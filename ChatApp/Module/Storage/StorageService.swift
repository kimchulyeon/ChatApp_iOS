//
//  StorageService.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import Foundation
import Combine
import FirebaseFirestore


let DB = Firestore.firestore()

enum ProviderType: String, Codable {
    case email
    case apple
    case google
}

struct UserData: Codable {
    @ServerTimestamp var createdAt: Date?
    let userId: String
    let name: String?
    let email: String?
    let provider: ProviderType
}


class StorageService {
    static let USERS_COLLECTION = DB.collection("users")

    static func storageUserData(_ userData: UserData) -> AnyPublisher<Void, Error> {
        let DOCUMENT = USERS_COLLECTION.document()
        let DOCUMENT_ID = DOCUMENT.documentID

        return Future<Void, Error> { promise in
            let data: [String: Any] = [
                "userId": userData.userId,
                "documentId": DOCUMENT_ID,
                "name": userData.name ?? "",
                "email": userData.email ?? "",
                "provider": userData.provider.rawValue,
                "createdAt": FieldValue.serverTimestamp()
            ]

            print("\n\(#file)파일\n \(#line)줄\n \(#function)함수\n데이터베이스에 유저 정보 저장 >>>> \n")
            
            DOCUMENT.setData(data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
            .eraseToAnyPublisher()
    }
}
