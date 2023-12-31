//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/15/23.
//

import UIKit
import PhotosUI
import Combine

class RegisterViewModel {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()

    @Published var image: UIImage?
    @Published var pickerResults: [PHPickerResult] = []
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var isLoading: Bool = false

    private var registerValidPublisher: AnyPublisher<(Bool, Bool), Never> {
        let nameValid = name.trimmingCharacters(in: .whitespaces).isEmpty == false
        let emailValid = email.isEmpty == false
        let passwordValid = !password.isEmpty && !passwordCheck.isEmpty
        let passwordCheckValid = password == passwordCheck
        let valid = nameValid && emailValid && passwordValid
        return Just((valid, passwordCheckValid)).eraseToAnyPublisher()
    }
    
    let registerButtonTapSubject = PassthroughSubject<Void, Never>()
    var registerResultPublisher: AnyPublisher<AuthResult, Never> {
        registerButtonTapSubject
            .coolDown(for: .seconds(3), scheduler: DispatchQueue.main)
            .flatMap { [unowned self] _ in handleRegister() }
            .eraseToAnyPublisher()
    }


    //MARK: - lifecycle
    init() {
        bind()
    }


    //MARK: - method
    private func bind() {
        bindPickerImage()
    }

    private func bindPickerImage() {
        $pickerResults
            .filter { $0.isEmpty == false }
            .sink { [weak self] results in
                guard let result = results.map(\.itemProvider).first else { return }

                if result.canLoadObject(ofClass: UIImage.self) {
                    result.loadObject(ofClass: UIImage.self) { image, error in
                        guard let image = image as? UIImage, error == nil else { return }
                        self?.image = image
                    }
                }
            }
            .store(in: &cancellables)
    }

    func handleRegister() -> AnyPublisher<AuthResult, Never> {
        return registerValidPublisher
            .flatMap { [weak self] (valid, passwordCheckValid) in
                guard let weakSelf = self else { return Just(AuthResult.failure(error: AuthError.unknown)).eraseToAnyPublisher() }

                if valid == false {
                    return Just(AuthResult.failure(error: AuthError.textFieldEmpty)).eraseToAnyPublisher()
                } else if passwordCheckValid == false {
                    return Just(AuthResult.failure(error: AuthError.passwordDiff)).eraseToAnyPublisher()
                }

                weakSelf.isLoading = true
                let credential = AuthCredentialWithEmail(email: weakSelf.email, 
                                                        password: weakSelf.password,
                                                        name: weakSelf.name,
                                                        provider: .email)
                
                return AuthService.shared.register(credential: credential)
                    .flatMap { userData in
                        StorageService.saveUserData(userData)
                    }
                    .flatMap { userData in
                        StorageService.uploadImage(with: userData.userId, weakSelf.image ?? UIImage(named: "chat_logo")!)
                    }
                    .map { url in
                        UserDefaultsManager.saveUserImage(url: url)
                    }
                    .map { _ in AuthResult.success }
                    .replaceError(with: AuthResult.failure(error: AuthError.registerError))
                    .handleEvents(receiveCompletion: { _ in
                        weakSelf.isLoading = false
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

}
