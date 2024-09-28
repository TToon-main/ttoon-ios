//
//  TabBarCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 5/31/24.
//

import UIKit

// 승섭 : 대부분 제가 직접 짠 코드가 많아서,, 좋은 코드가 아닐 수 있습니다. 좋은 아이디어 있으시면 언제든 환영입니다

// 8/17 코디네이터 적용해서 작업
// 홈, 피드, 출석체크, 마이페이지

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
    
    
    // 3. 현재 활성화되어있는 자식 코디네이터 배열. 탭바 코디의 경우, 예외적으로 여러 자식 코디가 활성화될 수 있습니다. (당연한 소리)
    var childCoordinators: [Coordinator] = []
    
    
    // 4.
    var type: CoordinatorType = .tabBar
    
    
    // 5.
    func start() {
        let pages: [ChildCoordinatorType] = [
            .calendar,
            .feed,
            .attendance,
            .myPage
        ]
        
        let controllers: [UINavigationController] = pages.map {
            getFlow($0).navigationController
        }
        
        prepareTabBarController(with: controllers)
        
        navigationController.viewControllers = [tabBarController]
        
        // 탭바 코디의 네비게이션은 굳이 보일 필요 없습니다.
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

extension TabBarCoordinator {
    // 탭바의 경우, 예외적으로 자식 코디를 직접 생성합니다.
    private func getFlow(_ page: ChildCoordinatorType) -> Coordinator {
        // 자식코디에 들어갈 nav
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: page.title,
            image: page.image,
            selectedImage: page.image
        )
        
        switch page {
        case .calendar:
            let c = CalendarSceneCoordinator(nav)
            childCoordinators.append(c)
            c.finishDelegate = self
            c.start()
            return c
            
        case .feed:
            let c = FeedSceneCoordinator(nav)
            childCoordinators.append(c)
            c.finishDelegate = self
            c.start()
            return c
            
        case .attendance:
            let c = AttendanceSceneCoordinator(nav)
            childCoordinators.append(c)
            c.finishDelegate = self
            c.start()
            return c
            
        case .myPage:
            let c = MyPageSceneCoordinator(nav)
            childCoordinators.append(c)
            c.finishDelegate = self
            c.start()
            return c
        }
    }
    
    
    
    // 탭바 컨트롤러 세팅
    private func prepareTabBarController(with navControllers: [UINavigationController]) {
        tabBarController.setViewControllers(navControllers, animated: true)
        
        tabBarController.tabBarItem.isEnabled = true
        
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = .tnOrange
        tabBarController.tabBar.unselectedItemTintColor = .grey05
        tabBarController.tabBar.backgroundColor = .white
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
        case calendar
        case feed
        case attendance
        case myPage
        
        // 탭바 내 아이콘의 이미지, 타이틀을 여기서 정하면 될 듯 합니다.
        var title: String {
            switch self {
            case .calendar:
                "캘린더"
            case .feed:
                "피드"
            case .attendance:
                "출석체크"
            case .myPage:
                "마이페이지"
            }
        }
        
        var image: UIImage {
            switch self {
            case .calendar:
                TNImage.tabBarCalendar!

            case .feed:
                TNImage.tabBarFeed!

            case .attendance:
                TNImage.tabBarAttendace!

            case .myPage:
                TNImage.tabBarMyPage!
            }
        }
        
        // selectedImage와 unselectedImage를 따로 설정해도 좋습니다. (UI 나온 후 결정)
    }
}








// (승섭 : 출석체크 폴더가 따로 없어서 일단 여기에 두었습니다)
// 3. AttendanceScene코디
protocol AttendanceSceneCoordinatorProtocol: Coordinator {
    // view
}
class AttendanceSceneCoordinator: AttendanceSceneCoordinatorProtocol {
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ nav: UINavigationController) {
        self.navigationController = nav
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .attendanceScene
    
    // 5.
    func start() {
        let repo = AttendanceRepository()
        let useCase = AttendanceUseCase(repo: repo)
        let reactor = AttendanceReactor(useCase: useCase)
        let vc = AttendanceViewController(attendanceReactor: reactor)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Protocol Method
}
extension AttendanceSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
