//
//  CalendarSceneCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit



protocol CalendarSceneCoordinatorProtocol: Coordinator {
    // view
    func showAddFriendView()
}
class CalendarSceneCoordinator: CalendarSceneCoordinatorProtocol {
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
    var type: CoordinatorType = .calendarScene
    
    // 5.
    func start() {
        print("start CalendarSceneCoordinator")
        let reactor = HomeCalendarReactor()
        let vc = HomeCalendarViewController(reactor: reactor)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Protocol Method
    func showAddFriendView() {
        print(#function)
    }
}
extension CalendarSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print("CalendarSceneCoordinator finish")
    }
}
