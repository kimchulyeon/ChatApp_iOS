//
//  Login.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/13/23.
//

import Foundation

enum LoginError: Error {
    case unknown
    case textFieldEmpty
}

enum LoginResult {
    case success
    case failure(error: LoginError)
}
