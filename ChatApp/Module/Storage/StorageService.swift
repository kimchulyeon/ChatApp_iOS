//
//  StorageService.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore


let DB = Firestore.firestore()

class StorageService {
    static let USERS_COLLECTION = DB.collection("users")

    /// 유저 데이터 데이터베이스에 저장
    static func storageUserData(_ userData: UserData) -> AnyPublisher<UserData, Error> {
        let DOCUMENT = USERS_COLLECTION.document()
        let DOCUMENT_ID = DOCUMENT.documentID

        return Future<UserData, Error> { promise in
            let data: [String: Any] = [
                "userId": userData.userId ?? "",
                "documentId": DOCUMENT_ID,
                "name": userData.name ?? "",
                "email": userData.email ?? "",
                "provider": userData.provider ?? "",
                "createdAt": FieldValue.serverTimestamp()
            ]

            print("\n\(#file)파일\n \(#line)줄\n \(#function)함수\n데이터베이스에 유저 정보 저장 >>>> \n")
            let userData = UserData(userId: userData.userId ?? "",
                                    documentId: DOCUMENT_ID,
                                    name: userData.name ?? "",
                                    email: userData.email ?? "",
                                    provider: userData.provider ?? "")
            
            DOCUMENT.setData(data) { error in
                if let error = error { promise(.failure(error)) }
                else { promise(.success(userData)) }
            }
        }
            .eraseToAnyPublisher()
    }
    
    
    /// userID로 해당하는 사용자 데이터 DB에서 가져오기
    static func getUserData(with authResult: AuthDataResult?) -> AnyPublisher<UserData, Error> {
        return Future<UserData, Error> { promise in
            guard let userId = authResult?.user.uid else { return promise(.failure(AuthError.loginError)) }
            
            USERS_COLLECTION.whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
                if let error = error { return promise(.failure(error)) }
                
                if let snapshot = snapshot, let userDocument = snapshot.documents.first {
                    let storedData = userDocument.data()
                    let userData = UserData(createdAt: storedData["createdAt"] as? Date,
                                            userId: storedData["userId"] as? String,
                                            documentId: userDocument.documentID,
                                            name: storedData["name"] as? String,
                                            email: storedData["email"] as? String,
                                            provider: storedData["provider"] as? String)
                    
                    print("🔵 데이터베이스에 있는 유저입니다 <<<< ")
                    promise(.success(userData))
                } else {
                    print("🌕 데이터베이스에 없는 유저입니다 <<<< ")
                    return promise(.failure(AuthError.noDataInDB))
                }
            }
        }.eraseToAnyPublisher()
    }
}
