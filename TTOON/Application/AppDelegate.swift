//
//  AppDelegate.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 3/24/24.
//

import UIKit

import FirebaseAnalytics
import FirebaseCore
 import IQKeyboardManagerSwift
import KakaoSDKCommon


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpSDK()
        setUpAppearance()
        startNetworkMonitoring()
        setUpKeyboard()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    private func setUpSDK() {
        // Firebase Analytics
        FirebaseApp.configure()
//        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        // Kakao Login
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String
        KakaoSDK.initSDK(appKey: kakaoAppKey ?? "")
    }
    
    private func startNetworkMonitoring() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    private func setUpAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [
            .font: UIFont.body16m,
            .foregroundColor: UIColor.grey08
        ]
        
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setUpKeyboard() {
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
}
