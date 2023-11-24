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
        return oAuthCredentialPublisher(according: type)
            .flatMap { [weak self] oAuthCredential in
                self?.isLoading = true
                return AuthService.shared.oAuth(provider: .apple, credential: oAuthCredential)
            }
            .flatMap { [weak self] authResult in
                StorageService.getUserData(with: authResult)
                    .catch { _ in // 신규 유저
                        let userData = UserData(userId: authResult?.user.uid,
                                                name: authResult?.user.displayName,
                                                email: authResult?.user.email,
                                                provider: type.rawValue)
                        
                        return StorageService.saveUserData(userData)
                    }
                    .handleEvents(receiveCompletion: { [weak self] _ in
                        self?.isLoading = false
                    })
            }
            .flatMap { userData in
                UserDefaultsManager.saveUserInfo(userData: userData)
            }
            .flatMap { userData in
                StorageService.uploadImage(with: userData.userId, UIImage(named: "chat_logo")!)
            }
            .flatMap { url in
                UserDefaultsManager.saveUserImage(url: url)
            }
            .map { _ in
                AuthResult.success
            }
            .replaceError(with: AuthResult.failure(error: AuthError.loginError))
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .eraseToAnyPublisher()
    }
    
    func afterSuccessLogin() {
        let chatViewModel = ChatListViewModel()
        let c_navigationController = UINavigationController(rootViewController: ChatListViewController(viewModel: chatViewModel))
        
        CommonUtil.changeRootView(to: c_navigationController)
    }
}


//MARK: - helper
extension LoginViewModel {
    /// 로그인 제공자 타입에 따라 반환받은 Credential를 가진 퍼블리셔를 리턴
    private func oAuthCredentialPublisher(according type: ProviderType) -> AnyPublisher<AuthCredential, Error> {
        var servicePublisher: AnyPublisher<AuthCredential, Error>
        
        switch type {
            case .apple: servicePublisher = AppleService.shared.appleOAuthCredentialPublisher
            case .google: servicePublisher = GoogleService.shared.googleOAuthCredentialPublisher
            case .email: servicePublisher = Empty<AuthCredential, Error>().eraseToAnyPublisher()
        }
        
        return servicePublisher
    }
}
