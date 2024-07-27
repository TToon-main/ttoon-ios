//
//  AuthCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 5/31/24.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    // view
    func showSplashView()
    func showLoginView()
}

class AuthCoordinator: AuthCoordinatorProtocol {
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
    var type: CoordinatorType = .auth
    
    // 5.
    func start() {
        showSplashView()
    }
    
    
    // Protocol Method
    func showSplashView() {
        // 스플래시 뷰 등장
        // 스플래시 뷰모델에 클로저로 showLoginView() 를 연결합니다.
        // 즉, 스플래시 뷰모델에서 이벤트 발생 -> 코디에서 showLoginView() 실행 로직입니다.
    }
    
    func showLoginView() {
        // 로그인 뷰 등장
    }
}


extension AuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        
        // TODO: 다음 화면 로직
    }
}
