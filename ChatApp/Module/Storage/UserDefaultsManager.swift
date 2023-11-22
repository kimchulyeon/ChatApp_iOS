//
//  UserDefaultsManager.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import Foundation
import Combine

struct UserDefaultsManager {
    @discardableResult
    static func saveUserInfo(userData: UserData) -> AnyPublisher<UserData, Never> {
        UserDefaults.standard.set(userData.name, forKey: Key.Name.value)
        UserDefaults.standard.set(userData.email, forKey: Key.Email.value)
        UserDefaults.standard.set(userData.documentId, forKey: Key.DocID.value)
        UserDefaults.standard.set(userData.userId, forKey: Key.UID.value)
        
        print(userData)
        print("\n\(#file)파일\n \(#line)줄\n \(#function)함수\n🟢 UserDefaults에 사용자 정보 저장 >>>> \n")
        return Just(userData).eraseToAnyPublisher()
    }
    
    static func saveUserImage(url: String?) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let url = url else { return promise(.failure(AuthError.unknown)) }
            
            UserDefaults.standard.set(url, forKey: Key.Image.value)
            return promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    static func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    static func checkUserDefaultsValues() {
        let name = UserDefaults.standard.object(forKey: Key.Name.value)
        let email = UserDefaults.standard.object(forKey: Key.Email.value)
        let documentId = UserDefaults.standard.object(forKey: Key.DocID.value)
        let userId = UserDefaults.standard.object(forKey: Key.UID.value)
        
        print("이름 : \(name ?? "")")
        print("이메일 : \(email ?? "")")
        print("폴더 ID : \(documentId ?? "")")
        print("유저 ID : \(userId ?? "")")
    }
   
    static func getSingleData(key: Key) -> AnyPublisher<Any?, Never> {
        return Just(UserDefaults.standard.object(forKey: key.value)).eraseToAnyPublisher()
    }
}
