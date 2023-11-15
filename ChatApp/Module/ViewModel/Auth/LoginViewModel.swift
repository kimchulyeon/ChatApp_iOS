//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import Combine
import CombineCocoa

class LoginViewModel: ViewModelType {
    //MARK: - properties
    @Published var email: String = ""
    @Published var password: String = ""
    
    private var loginValidPublisher: AnyPublisher<Bool, Never> {
        let idValid = email.trimmingCharacters(in: .whitespaces).isEmpty == false
        let pwValid = password.isEmpty == false
        let valid = idValid && pwValid
        return Just(valid).eraseToAnyPublisher()
    }

    //MARK: - lifecycle


    //MARK: - method
    func handleLogin() -> AnyPublisher<AuthResult, Never> {
        loginValidPublisher
            .flatMap { isValid in
                print("✅")
                if isValid == false {
                    return Just(AuthResult.failure(error: AuthError.textFieldEmpty))
                }
                return Just(AuthResult.success)
            }
            .eraseToAnyPublisher()
    }
}
