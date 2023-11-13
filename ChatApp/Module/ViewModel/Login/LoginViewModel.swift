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
    
    private var id: String = ""
    private var pw: String = ""
    
    @Published private var isLoginButtonTapped = CurrentValueSubject<Bool, Never>(false)
    @Published private (set) var isSucceedSubject = PassthroughSubject<Bool, Never>()
    @Published private (set) var isLoadingSubject = PassthroughSubject<Bool, Never>()
    @Published private var isValidSubject = CurrentValueSubject<Bool?, Never>(nil)
    
    
    struct Input {
        let emailPublisher: AnyPublisher<String, Never>
        let passwordPublisher: AnyPublisher<String, Never>
        let loginTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isLoadingPublisher: AnyPublisher<Bool, Never>
        let isValidPublisher: AnyPublisher<Bool?, Never>
    }
    //MARK: - lifecycle
    
    
    //MARK: - method
    func bind(input: Input) -> Output {
        input.loginTapPublisher
            .sink(receiveValue: { [weak self] _ in
                guard let weakSelf = self else { return }
                
                weakSelf.isLoginButtonTapped.send(true)
                
                if weakSelf.isValidSubject.value == true {
                    weakSelf.handleLogin(id: weakSelf.id, pw: weakSelf.pw)
                }
            })
            .store(in: &cancellables)
        
        input.emailPublisher.combineLatest(input.passwordPublisher)
            .sink { [weak self] email, password in
                guard let weakSelf = self else { return }
                
                let emailValid = email.trimmingCharacters(in: .whitespaces).isEmpty == false
                let passwordValid = password.isEmpty == false
                let valid = emailValid && passwordValid
                
                if weakSelf.isLoginButtonTapped.value == true {
                    weakSelf.isValidSubject.send(valid)
                }
            }
            .store(in: &cancellables)
        
        let output = Output(isLoadingPublisher: isLoadingSubject.eraseToAnyPublisher(),
                            isValidPublisher: isValidSubject.eraseToAnyPublisher())
        return output
    }
    
    private func handleLogin(id: String, pw: String) {
        isLoadingSubject.send(true)
        print("LOGIN TAP ✅", id, pw)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            guard let weakSelf = self else { return }
//            weakSelf.isLoadingSubject.send(false)
//            weakSelf.isSucceedSubject.send(true)
//        }
        isLoadingSubject.send(false)
        isSucceedSubject.send(true)
    }
}
