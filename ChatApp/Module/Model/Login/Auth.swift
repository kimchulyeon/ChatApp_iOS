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
}

enum AuthResult {
    case success
    case failure(error: AuthError)
}
