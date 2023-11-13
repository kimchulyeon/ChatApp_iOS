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
    
    @Published private (set) var id: String = ""
    @Published private (set) var password: String = ""
    private var isValid: Bool {
        let idValid = id.trimmingCharacters(in: .whitespaces).isEmpty == false
        let pwValid = password.isEmpty == false
        
        return idValid && pwValid
    }
    
    struct Input {
        let emailPublisher: AnyPublisher<String, Never>
        let passwordPublisher: AnyPublisher<String, Never>
    }
    
    //MARK: - lifecycle
    
    
    //MARK: - method
    func bind(input: Input) {
        input.emailPublisher
            .sink { [weak self] email in
                self?.id = email
            }
            .store(in: &cancellables)
        
        input.passwordPublisher
            .sink { [weak self] password in
                self?.password = password
            }
            .store(in: &cancellables)
    }
    
    
    func handleLogin() -> AnyPublisher<LoginResult, Never> {
        guard isValid else { return Just(LoginResult.failure(error: LoginError.textFieldEmpty)).eraseToAnyPublisher() }
        return Just(LoginResult.success).eraseToAnyPublisher()
    }
}
