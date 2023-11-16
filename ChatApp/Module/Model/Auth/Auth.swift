//
//  Auth.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/13/23.
//

import Foundation

enum AuthError: Error {
    case unknown
    case textFieldEmpty
    case passwordDiff
    case registerError
    case loginError
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
        case .error:
            ["😥", "😖", "😳", "😵", "☹️"].randomElement()!
        case .warning:
            "🙄"
        case .success:
            "🤗"
        }
    }
}
