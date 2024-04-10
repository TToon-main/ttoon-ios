//
//  AppCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

// Every app should have one main coordinator (start point of all flow) => AppCoordinator

// MARK: - App Coordinator Protocol
protocol AppCoordinatorProtocol: Coordinator {
    // view
    
    // flow

}

// MARK: - App Coordinator Class
class AppCoordinator: AppCoordinatorProtocol {
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate? = nil   // AppCoordinator : 부모 코디 x
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .app
    
    // 5.
    func start() {
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
     
    }
}

// MARK: - Child Coordinator 타입
extension AppCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        // auth, ...
    }
}
