//
//  GoogleService.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/17/23.
//

import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import Combine

final class GoogleService {
    static let shared = GoogleService()
    private init() { }

    private let googleOAuthCredentialSubject = PassthroughSubject<AuthCredential, Error>()
    var googleOAuthCredentialPublisher: AnyPublisher<AuthCredential, Error> {
        googleOAuthCredentialSubject.eraseToAnyPublisher()
    }
}



extension GoogleService {
    func startSignInWithGoogleFlow(with view: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let user = result?.user,
                    let idToken = user.idToken?.tokenString else {

                    print("Error There is no user or idToken while google sign in :::::::: ❌")
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                self?.googleOAuthCredentialSubject.send(credential)
            }
        }
    }
}
