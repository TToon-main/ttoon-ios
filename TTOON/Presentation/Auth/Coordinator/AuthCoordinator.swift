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
    func showSplashErrorView(status: SplashStatus)
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
        
        
        // TODO: DI 구성 후 아래 내용 작업 필요
        let repo = SplashRepository()
        let useCase = SplashUseCase(splashRepository: repo)
        let reactor = SplashReactor(splashUseCase: useCase)
        
        
        reactor.sendTransitionEvent = { [weak self] event in
            // 2초 딜레이 부여
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                switch event {
                case .goSplashErrorView(let splashStatus):
                    print("코디 : go Splash Error View")
                    self?.showSplashErrorView(status: splashStatus)
                    
                case .goLoginView:
                    print("코디 : go Login View")
                    self?.showLoginView()
                    
                case .goHomeView:
                    print("코디 : go Home view")
//                    self?.showTabbarView()
                    // AuthC 종료 -> AppC에서 TabBarC.start() -> HomeVC 시작
                    self?.finish(AppCoordinator.ChildCoordinatorType.tabBar)
                }
            }
        }
        
        let vc = SplashViewController(splashReactor: reactor)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSplashErrorView(status: SplashStatus) {
        // TODO: DI 구성 후 아래 내용 작업 필요
        let repo = SplashRepository()
        let useCase = SplashUseCase(splashRepository: repo)
        let reactor = SplashErrorReactor(splashUseCase: useCase, splashStatus: status)
        
        reactor.sendTransitionEvent = { [weak self] event in
            // 2초 딜레이 부여
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                switch event {
                case .goSplashErrorView(let splashStatus):
                    self?.showSplashErrorView(status: splashStatus)
                    
                case .goLoginView:
                    self?.navigationController.topViewController?.dismiss(animated: true) {
                        self?.showLoginView() 
                    }
                    
                case .goHomeView:
                    self?.showTabbarView()
                }
            }
        }
        
        
        let vc = SplashErrorViewController(splashErrorReactor: reactor)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.topViewController?.present(vc, animated: true)
        
        // 원래 present로 올리는 건 좀 예외적으로 코디를 새로 만들긴 하는데,
        // 이 vc에 이어지는 VC가 없기 때문에 (즉, 더 이상 화면 전환이 없기 때문에
        // 여기 코디에서 모두 담당하기로 하겠습니다.
    }
    
    func showLoginView() {
        // 로그인 뷰 등장
        let repo = LoginRepository()
        let useCase = LoginUseCase(loginRepository: repo)
        let vm = LoginViewModel(loginUseCase: useCase)
        let vc = LoginViewController.create(with: vm)
        
        // VM과 코디 사이의 이벤트 교환
        vm.didSendEventClosure = { [weak self] event in
            switch event {
            case .goTabBarFlow:
                // (아마 로그인 성공 시)
                // 탭바를 띄워야 한다.
                
                // 1. 현재 떠있는 Auth 코디 종료
                // 2. App코디에게 TabBar 코디 실행하라고 요청
                self?.finish(AppCoordinator.ChildCoordinatorType.tabBar)
            }
        }
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.topViewController?.present(vc, animated: true)
    }
    
    func showTabbarView() {
        let tabbar = TabbarViewController()
        tabbar.modalTransitionStyle = .crossDissolve
        tabbar.modalPresentationStyle = .overCurrentContext
        
        navigationController.topViewController?.present(tabbar, animated: true)
    }
}


extension AuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        // (8/17) 현재 Auth코디는 자식 코디가 없기 때문에 이 메서드가 실행될 일이 없습니다.
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        
        // TODO: 다음 화면 로직
    }
}
