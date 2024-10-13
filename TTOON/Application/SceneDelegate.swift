//
//  SceneDelegate.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 3/24/24.
//

import GoogleSignIn
import KakaoSDKAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let nav = UINavigationController()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(nav)
        appCoordinator?.start()
//        addCreationToastView()
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
            
            else {
                _ = GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
    
    func logout() {
        KeychainStorage.shared.removeAllKeys()
        
        guard let window = UIApplication.shared.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            let nav = UINavigationController()
            window.rootViewController = nav
            window.makeKeyAndVisible()
            self.appCoordinator = AppCoordinator(nav)
            self.appCoordinator?.start()
        }
    }
    
//    func addCreationToastView() {
//        ToonCreationToastView.shared.addView()
//        ToonCreationToastView.shared.status = .ing
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            ToonCreationToastView.shared.status = .complete
//        }
//    }
}
