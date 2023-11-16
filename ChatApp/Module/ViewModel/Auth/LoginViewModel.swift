//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import Combine
import CombineCocoa

class LoginViewModel {
    //MARK: - properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    
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
            .flatMap { [weak self] isValid in
                guard let weakSelf = self else { return Just(AuthResult.failure(error: AuthError.loginError)).eraseToAnyPublisher() }
                
                if isValid == false {
                    return Just(AuthResult.failure(error: AuthError.textFieldEmpty)).eraseToAnyPublisher()
                }

                weakSelf.isLoading = true
                return AuthService.shared.login(email: weakSelf.email, password: weakSelf.password)
                    .flatMap { authResult in
                        return StorageService.getUserData(with: authResult)
                    }
                    .map { userData in
                        UserDefaultsManager.saveUserInfo(userData: userData)
                        return AuthResult.success
                    }
                    .replaceError(with: AuthResult.failure(error: AuthError.loginError))
                    .handleEvents(receiveCompletion: { _ in
                        weakSelf.isLoading = false
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
