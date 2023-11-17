//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import Combine
import CombineCocoa
import FirebaseAuth

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
    
    let loginButtonTapSubject = PassthroughSubject<Void, Never>()
    var loginResultPublisher: AnyPublisher<AuthResult, Never> {
        loginButtonTapSubject
            .coolDown(for: .seconds(3), scheduler: DispatchQueue.main)
            .flatMap { [unowned self] _ in handleLogin() }
            .eraseToAnyPublisher()
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


    func handleOAuthLogin(type: ProviderType) -> AnyPublisher<AuthResult, Never> {
        var servicePublisher: AnyPublisher<AuthCredential, Error>
        switch type {
            case .apple: servicePublisher = AppleService.shared.appleOAuthCredentialPublisher
            case .google: servicePublisher = GoogleService.shared.googleOAuthCredentialPublisher
            default: servicePublisher = Fail(error: AuthError.loginError).eraseToAnyPublisher()
        }
        
        return servicePublisher
            .flatMap { [weak self] oAuthCredential in
                self?.isLoading = true
                return AuthService.shared.oAuth(provider: .apple, credential: oAuthCredential)
            }
            .flatMap { [weak self] authResult in
                return StorageService.getUserData(with: authResult)
                    .catch { _ in
                        let userData = UserData(userId: authResult?.user.uid,
                                                name: authResult?.user.displayName,
                                                email: authResult?.user.email,
                                                provider: type.rawValue)
                        return StorageService.storageUserData(userData)
                    }
                    .handleEvents(receiveCompletion: { _ in
                        self?.isLoading = false
                    })
            }
            .map { userData in
                UserDefaultsManager.saveUserInfo(userData: userData)
                return AuthResult.success
            }
            .replaceError(with: AuthResult.failure(error: AuthError.loginError))
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .eraseToAnyPublisher()
    }
}
