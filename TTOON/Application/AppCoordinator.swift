//
//  AppCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import AVFoundation
import Photos
import UIKit


// Every app should have one main coordinator (start point of all flow) => AppCoordinator

// MARK: - App Coordinator Protocol
protocol AppCoordinatorProtocol: Coordinator {
    // view
    
    // flow
    func showAuthFlow()
    func showTabBarFlow()
}

// MARK: - App Coordinator Class
class AppCoordinator: AppCoordinatorProtocol {
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate? = nil   // AppCoordinator : 부모 코디 x
    
    // 2.
    var navigationController: UINavigationController
    required init(_ nav: UINavigationController) {
        self.navigationController = nav
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .app
    
    // 5.
    func start() {
        showAuthFlow()
        requestPermission()
//        showTabBarFlow()
    }
    
    
    // Protocol Method
    func showAuthFlow() {
        let authC = AuthCoordinator(navigationController)
        authC.finishDelegate = self
        childCoordinators.append(authC)
        authC.start()
    }
    
    func requestPermission() {
        // 카메라
        AVCaptureDevice.requestAccess(for: .video) { _ in }
        
        // 앨범
        PHPhotoLibrary.requestAuthorization{ _ in }
    }
    
    func showTabBarFlow() {
        let tabBarC = TabBarCoordinator(navigationController)
        tabBarC.finishDelegate = self
        childCoordinators.append(tabBarC)
        tabBarC.start()
    }
}

// MARK: - Child Didfinished
extension AppCoordinator: CoordinatorFinishDelegate {
    // CoordinatorFinishDelegate
    func coordinatorDidFinish(
        childCoordinator: Coordinator,
        nextFlow: ChildCoordinatorTypeProtocol?
    ) {
        /* 부모 코디에게 연락이 올 때 : 다음 타겟 코디가 누구인지 알려준다 */
        // 1. Child
        // 2. Child의 Child (직접 찾아야 함)
        // 3. 부모 타고 가야 하는 코디

        print("App 코디 : child finish 연락 받음. nextFlow : \(nextFlow)")
        // 1. App 코디의 child인 경우 (auth, tabBar)
        if let nextFlow = nextFlow as? AppCoordinator.ChildCoordinatorType {
            switch nextFlow {
            case .auth:
                print("auth 코디 실행해야 한다!")
            
            case .tabBar:
                print("tabBar 코디 실행해야 한다!")
                self.showTabBarFlow()
            }
        }
        
        
        
        // 2. 기타 코디일 가능성도 있음 (tabBar의 child, ...)
        
     
    }
}

// MARK: - Child Coordinator 타입
extension AppCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case auth
        case tabBar
    }
}
