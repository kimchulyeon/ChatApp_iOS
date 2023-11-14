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
    private var cancellables = Set<AnyCancellable>()

    @Published var email: String = ""
    @Published var password: String = ""
    private var loginValidPublisher: AnyPublisher<Bool, Never> {
        let idValid = email.trimmingCharacters(in: .whitespaces).isEmpty == false
        let pwValid = password.isEmpty == false
        return Just(idValid && pwValid).eraseToAnyPublisher()
    }

    //MARK: - lifecycle


    //MARK: - method
    func handleLogin() -> AnyPublisher<LoginResult, Never> {
        loginValidPublisher
            .flatMap { isValid in
                print("✅")
                if isValid == false {
                    return Just(LoginResult.failure(error: LoginError.textFieldEmpty))
                }
                return Just(LoginResult.success)
            }
            .eraseToAnyPublisher()
    }
}
