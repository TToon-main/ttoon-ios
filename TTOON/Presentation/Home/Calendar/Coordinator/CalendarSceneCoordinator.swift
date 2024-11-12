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

            case .showCompleteCreateToonView(let urls):
                self?.showCompleteCreateToonView(urls)
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
//        let repo = ToonRepository()
//        let useCase = ToonUseCase(repo: repo)
//        let reactor = EnterInfoReactor(useCase: useCase)
//        reactor.delegate = self.homeReactor 
//        
//        let vc = EnterInfoViewController(reactor: reactor)
//        vc.hidesBottomBarWhenPushed = true
        
        let reactor = CompleteToonReactor(urls: [])
        let vc = CompleteToonViewController(reactor: reactor)
        vc.modalPresentationStyle = .overFullScreen
        
        
        navigationController.navigationBar.topItem?.backButtonTitle = ""
        navigationController.navigationBar.tintColor = .black
        navigationController.pushViewController(vc, animated: true)
    }

    func showSearchFriendView() {
        let vc = SearchFriendViewController(reactor: SearchFriendReactor(SearchFriendUseCase(SearchFriendRepository())))
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showCompleteCreateToonView(_ urls: [String]) {
        let vc = CompleteCreateToonViewController(urls: urls)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        
        vc.didSendEventClosure = { [weak self] event in
            switch event {
            case .showCompleteToonView(let urls):
                
                let reactor = CompleteToonReactor(urls: urls)
                let vc = CompleteToonViewController(reactor: reactor)
                vc.modalPresentationStyle = .overFullScreen
                
                nav.pushViewController(vc, animated: true)
            }
        }
        
        navigationController.present(nav, animated: true)
    }
}
extension CalendarSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print("CalendarSceneCoordinator finish")
    }
}
