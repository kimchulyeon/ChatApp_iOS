//
//  Auth.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/13/23.
//

import Foundation
import FirebaseFirestore

struct AuthCredentialWithEmail {
    let email: String
    let password: String
    let name: String
    let provider: ProviderType
    
}

enum AuthError: Error {
    case unknown
    case textFieldEmpty
    case passwordDiff
    case registerError
    case loginError
    case noDataInDB
}

enum AuthResult {
    case success
    case failure(error: AuthError)
}

enum EmojisType {
    case error
    case warning
    case success
    
    var emoji: String {
        switch self {
        case .error: ["😥", "😖", "😳", "😵", "☹️"].randomElement()!
        case .warning: "🙄"
        case .success: "🤗"
        }
    }
}


enum ProviderType: String, Codable {
    case email
    case apple
    case google
}

struct UserData: Codable {
    @ServerTimestamp var createdAt: Date? = nil
    let userId: String?
    var documentId: String? = nil
    let name: String?
    let email: String?
    let provider: ProviderType.RawValue?
}
