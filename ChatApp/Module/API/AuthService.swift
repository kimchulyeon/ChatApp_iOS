//
//  AuthService.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/15/23.
//

import UIKit
import Combine
import FirebaseCore
import FirebaseAuth

struct AuthCredential {
    let email: String
    let password: String
    let name: String
    let provider: ProviderType
    let image: UIImage
}

class AuthService {
    static let shared = AuthService()
    private init() { }
    
    var cancellables = Set<AnyCancellable>()
    
    /// 로그인
    func login(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error> {
        return Future<AuthDataResult?, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("🔴 Login Error >>>> \(String(describing: error.localizedDescription))")
                    return promise(.failure(error))
                }
                
                return promise(.success(authResult))
            }
        }
            .eraseToAnyPublisher()
    }
    
    
    /// 회원가입
    func register(credential: AuthCredential) -> AnyPublisher<UserData, Error> {
        return Future<UserData, Error> { promise in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { authResult, error in
                if let error = error {
                    print("🔴 Register Error >>>> \(String(describing: error.localizedDescription))")
                    return promise(.failure(error))
                }
                
                
                guard let userId = authResult?.user.uid else { return promise(.failure(AuthError.unknown)) }
                let userData = UserData(userId: userId,
                                        name: credential.name,
                                        email: credential.email,
                                        provider: credential.provider.rawValue)
                
                return promise(.success(userData))
            }
        }
            .eraseToAnyPublisher()
    }
}
