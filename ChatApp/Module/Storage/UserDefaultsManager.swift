//
//  UserDefaultsManager.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/16/23.
//

import Foundation

struct UserDefaultsManager {
    static func saveUserInfo(name: String, email: String, docID: String, uid: String) {
        UserDefaults.standard.set(name, forKey: "Name")
        UserDefaults.standard.set(email, forKey: "Email")
        UserDefaults.standard.set(docID, forKey: "DocumentId")
        UserDefaults.standard.set(uid, forKey: "UserId")
        
        print("\n\(#file)파일\n \(#line)줄\n \(#function)함수\n🟢 UserDefaults에 사용자 정보 저장 >>>> \n")
    }
    
    func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
