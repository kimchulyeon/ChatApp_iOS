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

class AuthService {
    static let shared = AuthService()
    private init() { }
    
    var cancellables = Set<AnyCancellable>()
    
    /// 로그인
    func login(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error> {
        return Future<AuthDataResult?, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("🔴 Login Error >>>> \(error.localizedDescription)")
                    return promise(.failure(error))
                }
                
                return promise(.success(authResult))
            }
        }
            .eraseToAnyPublisher()
    }
    
    
    /// 회원가입
    func register(credential: AuthCredentialWithImg) -> AnyPublisher<UserData, Error> {
        return Future<UserData, Error> { promise in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { authResult, error in
                if let error = error {
                    print("🔴 Register Error >>>> \(error.localizedDescription)")
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
    
    
    /// OAuth
    func oAuth(provider: ProviderType, credential: AuthCredential) -> AnyPublisher<AuthDataResult?, Error> {
        return Future<AuthDataResult?, Error> { promise in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("🔴 OAuth Login Error >>>> \(error.localizedDescription)")
                    return promise(.failure(error))
                }
                
                return promise(.success(authResult))
            }
        }
        .eraseToAnyPublisher()
    }
}
