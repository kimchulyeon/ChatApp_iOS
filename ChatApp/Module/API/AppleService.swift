//
//  AppleService.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/17/23.
//

import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Combine

final class AppleService: NSObject {
    static let shared = AppleService()
    private override init() { }
    
    
    //MARK: - properties
    var initLoginFlowViewController: UIViewController! // 📌 인증 인터페이스를 LoginVC에서 제공하기 위해
    
    private let appleOAuthCredentialSubject = PassthroughSubject<AuthCredential, Error>()
    var appleOAuthCredentialPublisher: AnyPublisher<AuthCredential, Error> {
        appleOAuthCredentialSubject.eraseToAnyPublisher()
    }

    
    //MARK: - methods
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }



    // Unhashed nonce.
    fileprivate var currentNonce: String?


    /// 📌 애플 로그인 버튼 눌렀을 때 실행
    @available(iOS 13, *) 
    func startSignInWithAppleFlow(view: UIViewController) {
        self.initLoginFlowViewController = view

        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


//MARK: - ASAuthorizationControllerDelegate
extension AppleService: ASAuthorizationControllerDelegate {

    // 📌 로그인이 성공하면
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            appleOAuthCredentialSubject.send(credential)

        }
    }

    // 📌 로그인 에러 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign🔴  in with Apple errored: \(error)")
        appleOAuthCredentialSubject.send(completion: .failure(error))
    }
}

// 📌 loginView에서 startSignInWithAppleFlow(with: self)를 실행하여 loginView에서 인증 인터페이스가 제공되게 작성
extension AppleService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = initLoginFlowViewController.view.window else { fatalError("No Window") }
        return window
    }
}
