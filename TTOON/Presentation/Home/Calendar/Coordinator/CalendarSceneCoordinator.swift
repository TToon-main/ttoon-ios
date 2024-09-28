//
//  CalendarSceneCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit



protocol CalendarSceneCoordinatorProtocol: Coordinator {
    // view
    func showCalendarView()
    func showFriendListView()
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
        showCalendarView()
    }
    
    // Protocol Method
    func showCalendarView() {
        let reactor = HomeCalendarReactor(HomeCalendarUseCase(HomeCalendarRepository()))
        let vc = HomeCalendarViewController(reactor: reactor)
        
        reactor.didSendEventClosure = { [weak self] event in
            switch event {
            case .showFriendListView:
                self?.showFriendListView()
            }
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showFriendListView() {
        // 탭맨 뷰컨은 따로 뷰모델이 없기 때문에 VC에 didSendEventClosure 추가
        let vc = FriendTabViewController()
        vc.didSendEventClosure = { [weak self] event in
            switch event {
            case .showSearchFriendView:
                self?.showSearchFriendView()
            }
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showSearchFriendView() {
        let vc = SearchFriendViewController(reactor: SearchFriendReactor(SearchFriendUseCase(SearchFriendRepository())))
        
        navigationController.pushViewController(vc, animated: true)
    }
}
extension CalendarSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print("CalendarSceneCoordinator finish")
    }
}
