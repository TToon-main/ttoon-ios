//
//  TabBarCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 5/31/24.
//

import UIKit

// 승섭 : 대부분 제가 직접 짠 코드가 많아서,, 좋은 코드가 아닐 수 있습니다. 좋은 아이디어 있으시면 언제든 환영입니다


protocol TabBarCoordinatorProtocol: Coordinator {
    // 탭바 코디의 경우 예외적으로 showView 또는 showFlow 메서드가 없고, 탭바 컨트롤러를 가집니다.
    var tabBarController: UITabBarController { get set }
}


class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    var tabBarController: UITabBarController
    
    // 1. 부모 코디네이터 (- AppCoordinator)
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    
    // 2. 모든 코디네이터는 하나의 nav를 가집니다.
    var navigationController: UINavigationController
    required init(_ nav: UINavigationController) {
        self.navigationController = nav
        self.tabBarController = UITabBarController()    
        // 인스턴스를 여기서 생성하는 이유는... 잘 모르겠습니다. 필요 시 수정해도 되어보입니다.
    }
    
    
    // 3. 현재 활성화되어있는 자식 코디네이터 배열. 탭바 코디의 경우, 예외적으로 여러 자식 코디가 활성화될 수 있습니다.
    var childCoordinators: [Coordinator] = []
    
    
    // 4.
    var type: CoordinatorType = .tabBar
    
    
    // 5.
    func start() {
        let pages: [ChildCoordinatorType] = [
            .home,
            .setting,
            .reward
        ]
        
        let controllers: [UINavigationController] = pages.map {
            getFlow($0).navigationController
        }
        
        prepareTabBarController(with: controllers)
    }
}

extension TabBarCoordinator {
    // 탭바의 경우, 예외적으로 자식 코디를 직접 생성합니다.
    private func getFlow(_ page: ChildCoordinatorType) -> Coordinator {
        // 각 자식코디에 들어갈 nav
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: page.title,
            image: page.image,
            selectedImage: page.image
        )
        
        return AppCoordinator(nav)  // sample
        
        
//        // 코디 생성
//        switch page {
//        case .home:
//            let homeCoordinator = HomeCoordinator(nav)  // 1. 코디 인스턴스 생성
//            childCoordinators.append(homeCoordinator)      // 2. (활성화된) 자식 코디 배열에 추가
//            homeCoordinator.finishDelegate = self          // 3. 부모-자식 연결
//            homeCoordinator.start()                        // 4. 코디 플로우 시작
//            
//            return homeCoordinator
//
//        case .setting:
//            
//            let settingCoordinator = SettingCoordinator(nav)  // 1. 코디 인스턴스 생성
//            childCoordinators.append(settingCoordinator)      // 2. (활성화된) 자식 코디 배열에 추가
//            settingCoordinator.finishDelegate = self          // 3. 부모-자식 연결
//            settingCoordinator.start()                        // 4. 코디 플로우 시작
//            
//            return settingCoordinator
//            
//        case .reward:
//            
//            /* ... */
//        }
        
    }
    
    
    
    // 탭바 컨트롤러 세팅
    private func prepareTabBarController(with navControllers: [UINavigationController]) {
        tabBarController.setViewControllers(navControllers, animated: true)
        
        tabBarController.tabBarItem.isEnabled = true
        tabBarController.tabBar.tintColor = .blue
        
        
        // 탭바 코디의 네비게이션컨트롤러에 연결시킵니다.
        navigationController.viewControllers = [tabBarController]
        // 탭바 코디의 네비게이션은 굳이 보일 필요 없습니다.
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        // 자식 코디가 종료되었다는 소식을 받습니다.
        // 다음 화면 전환에 대한 로직을 작성합니다.
        
        // 다음 화면 전환을 직접 해주어야 하기 때문에, 여기는 아마 하드코딩.. 이 될 가능성이 높습니다.
        
        // ex). 로그아웃 or 회원탈퇴 -> Splash 로 이동
    }
}


// 탭바의 자식 코디네이터 정보
extension TabBarCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case home
        case setting
        case reward
        
        
        // 탭바 내 아이콘의 이미지, 타이틀을 여기서 정하면 될 듯 합니다.
        var title: String {
            switch self {
            case .home:
                "홈"
            case .setting:
                "설정"
            case .reward:
                "리워드"
            }
        }
        
        var image: UIImage {
            switch self {
            case .home:
                UIImage(systemName: "pencil")!

            case .setting:
                UIImage(systemName: "pencil")!

            case .reward:
                UIImage(systemName: "pencil")!
            }
        }
        
        // selectedImage와 unselectedImage를 따로 설정해도 좋습니다. (UI 나온 후 결정)
    }
}
