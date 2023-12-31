//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/10/23.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        window?.backgroundColor = ThemeColor.bg
        setRootViewController(window: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


// helper
extension SceneDelegate {
    /// UserDefaults에 docID가 저장되어 있으면 로그인된 유저
    private func setRootViewController(window: UIWindow?) {
        checkUserDefaultsDataForRootViewController(window)
            .sink { [weak self] isLogin in
                if isLogin == false {
                    self?.setBasicRootViewController(window)
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkUserDefaultsDataForRootViewController(_ window: UIWindow?) -> AnyPublisher<Bool, Never> {
        UserDefaultsManager.getSingleData(key: Key.DocID)
            .flatMap { data in
                guard let data = data as? String, data.isEmpty == false else { return Just(false).eraseToAnyPublisher() }
                
                let chatViewModel = ChatListViewModel()
                let c_navigationController = UINavigationController(rootViewController: ChatListViewController(viewModel: chatViewModel))
                
                window?.rootViewController = c_navigationController
                return Just(true).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func setBasicRootViewController(_ window: UIWindow?) {
        let loginViewModel = LoginViewModel()
        let navigationController = UINavigationController(rootViewController: LoginViewController(viewModel: loginViewModel))
        window?.rootViewController = navigationController
    }
}
