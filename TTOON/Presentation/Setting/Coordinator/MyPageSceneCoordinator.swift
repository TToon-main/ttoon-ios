//
//  MyPageSceneCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

protocol MyPageSceneCoordinatorProtocol: Coordinator {
    // view
    func showMyPageView()
    func showContactUsView()
    func showDeleteAccountView()
}
class MyPageSceneCoordinator: MyPageSceneCoordinatorProtocol {
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
    var type: CoordinatorType = .mypage
    
    // 5.
    func start() {
        print("start MyPageCoordinator")
        showMyPageView()
    }
    
    // Protocol Method
    func showMyPageView() {
        print(#function)
        
        let repository = MyPageRepository()
        let useCase = MyPageUseCase(repository: repository)
        let reactor = MyPageReactor(useCase: useCase)
        let vc = MyPageViewController(myPageReactor: reactor)
        navigationController.pushViewController(vc, animated: true)
    }
    func showContactUsView() {
        print(#function)
    }
    func showDeleteAccountView() {
        print(#function)
    }
}
extension MyPageSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
