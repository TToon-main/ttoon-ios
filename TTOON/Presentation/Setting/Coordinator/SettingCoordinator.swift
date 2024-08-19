////
////  SettingCoordinator.swift
////  TTOON
////
////  Created by 임승섭 on 5/31/24.
////
//
//// (8/17) 폐기 예정. MyPageSceneCoordinator 사용 예정
//
// import UIKit
//
// protocol SettingCoordinatorProtocol: Coordinator {
//    // view
//    func showMyPageView()
//    func showContactUsView()
//    func showDeleteAccountView()
// }
//
// class SettingCoordinator: SettingCoordinatorProtocol {
//    // 1.
//    weak var finishDelegate: CoordinatorFinishDelegate?
//    
//    // 2.
//    var navigationController: UINavigationController
//    required init(_ nav: UINavigationController) {
//        self.navigationController = nav
//    }
//    
//    // 3.
//    var childCoordinators: [Coordinator] = []
//    
//    // 4.
//    var type: CoordinatorType = .setting
//    
//    // 5.
//    func start() {
//        showMyPageView()
//    }
//    
//    
//    // Protocol Method
//    func showMyPageView() {
//        // 마이페이지 뷰
//        // 뷰모델에 클로저로 showContactUsView(), showDeleteAccountView() 연결
//    }
//    
//    func showContactUsView() {
//        // 문의하기 뷰
//        
//        // 클로저로 self.finish(.splash) 연결 (로그아웃 시 로그인 화면으로 이동한다)
//        // 이런 경우, 스플래시 화면이 아니라 로그인 화면으로 가야하는 경우가 있습니다.
//        // 추가적인 작업이 필요합니다. (Auth Coordinator의 start()에서는 showSplashView()를 실행하기 때문입니다)
//    }
//    
//    func showDeleteAccountView() {
//        // 탈퇴하기 뷰
//        
//        // 클로저로 self.finish(.splash) 연결 (탈퇴하기 시 스플래시로 이동한다)
//    }
// }
//
// extension SettingCoordinator: CoordinatorFinishDelegate {
//    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
//        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
//        navigationController.viewControllers.removeAll()
//        
//        // TODO: 다음 화면 로직
//    }
// }
