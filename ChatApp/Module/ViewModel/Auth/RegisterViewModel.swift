//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/15/23.
//

import UIKit
import PhotosUI
import Combine

class RegisterViewModel: ViewModelType {
    //MARK: - properties
    private var cancellables = Set<AnyCancellable>()
    
    @Published var image: UIImage?
    @Published var imageName: String?
    @Published var pickerResults: [PHPickerResult] = []
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    
    private var registerValidPublisher: AnyPublisher<(Bool, Bool), Never> {
        let nameValid = name.trimmingCharacters(in: .whitespaces).isEmpty == false
        let emailValid = email.isEmpty == false
        let passwordValid = !password.isEmpty && !passwordCheck.isEmpty
        let passwordCheckValid = password == passwordCheck
        let valid = nameValid && emailValid && passwordValid
        return Just((valid, passwordCheckValid)).eraseToAnyPublisher()
    }
    
    
    //MARK: - lifecycle
    init() {
        bind()
    }
    
    
    //MARK: - method
    private func bind() {
        $pickerResults
            .filter { $0.isEmpty == false }
            .sink { [weak self] results in
                guard let result = results.map(\.itemProvider).first, let name = results.map(\.assetIdentifier).first else { return }
                
                self?.imageName = name
 
                if result.canLoadObject(ofClass: UIImage.self) {
                    result.loadObject(ofClass: UIImage.self) { image, error in
                        guard let image = image as? UIImage, error == nil else  { return }
                        self?.image = image
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
    func handleRegister() -> AnyPublisher<AuthResult, Never> {
        registerValidPublisher
            .flatMap { [weak self] (valid, passwordCheckValid) in
                if valid == false {
                    return Just(AuthResult.failure(error: AuthError.textFieldEmpty))
                } else if passwordCheckValid == false {
                    return Just(AuthResult.failure(error: AuthError.passwordDiff))
                }
                
                #warning("REGISTER")
                if let email = self?.email, let password = self?.password, let name = self?.name {
                    let credential = AuthCredential(email: email, password: password, name: name, image: self?.image ?? UIImage(named: "chat_logo")!)
                }
                
                
                return Just(AuthResult.success)
            }
            .eraseToAnyPublisher()
    }
    
}
