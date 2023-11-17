//
//  UserDefaultsManager.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import Foundation

struct UserDefaultsManager {
    static func saveUserInfo(userData: UserData) {
        UserDefaults.standard.set(userData.name, forKey: "Name")
        UserDefaults.standard.set(userData.email, forKey: "Email")
        UserDefaults.standard.set(userData.documentId, forKey: "DocumentId")
        UserDefaults.standard.set(userData.userId, forKey: "UserId")
        
        print(userData)
        print("\n\(#file)파일\n \(#line)줄\n \(#function)함수\n🟢 UserDefaults에 사용자 정보 저장 >>>> \n")
    }
    
    static func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    static func checkUserDefaultsValues() {
        let name = UserDefaults.standard.object(forKey: "Name")
        let email = UserDefaults.standard.object(forKey: "Email")
        let documentId = UserDefaults.standard.object(forKey: "DocumentId")
        let userId = UserDefaults.standard.object(forKey: "UserId")
        
        print("이름 : \(name ?? "")")
        print("이메일 : \(email ?? "")")
        print("폴더 ID : \(documentId ?? "")")
        print("유저 ID : \(userId ?? "")")
    }
}
