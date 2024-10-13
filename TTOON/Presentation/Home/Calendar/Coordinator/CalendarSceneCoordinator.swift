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
    func showSearchFriendView()
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
    
    let homeReactor = HomeCalendarReactor(HomeCalendarUseCase(HomeCalendarRepository()), toonUseCase: ToonUseCase(repo: ToonRepository()))
    lazy var homeVC = HomeCalendarViewController(reactor: homeReactor)
    
    // Protocol Method
    func showCalendarView() {
        homeReactor.didSendEventClosure = { [weak self] event in
            switch event {
            case .showFriendListView:
                self?.showFriendListView()
                
            case .showCreateToonView:
                self?.showCreateToonView()
                
            case .showCompleteToonView(let urls):
                self?.showCompleteToonView(urls)
            }
        }
        
        navigationController.pushViewController(homeVC, animated: true)
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
    
    func showCreateToonView() {
        let repo = ToonRepository()
        let useCase = ToonUseCase(repo: repo)
        let reactor = EnterInfoReactor(useCase: useCase)
        reactor.delegate = self.homeReactor 
        
        let vc = EnterInfoViewController(reactor: reactor)
        vc.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.topItem?.backButtonTitle = ""
        navigationController.navigationBar.tintColor = .black
        navigationController.pushViewController(vc, animated: true)
    }

    func showSearchFriendView() {
        let vc = SearchFriendViewController(reactor: SearchFriendReactor(SearchFriendUseCase(SearchFriendRepository())))
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showCompleteToonView(_ urls: [String]) {
        let reactor = CompleteToonReactor()
        let vc = CompleteToonViewController(reactor: reactor)
        vc.modalPresentationStyle = .overCurrentContext
        
        navigationController.present(vc, animated: true)
    }
}
extension CalendarSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print("CalendarSceneCoordinator finish")
    }
}
