//
//  FeedSceneCoordinator.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

protocol FeedSceneCoordinatorProtocol: Coordinator {
    // view
    func showHomeFeedView()
    func showLikeUserListView(feedId: Int)
    
    func showFriendListView()
    func showSearchFriendView()
}
class FeedSceneCoordinator: FeedSceneCoordinatorProtocol {
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ nav: UINavigationController) {
        self.navigationController = nav
        self.navigationController.navigationBar.tintColor = .black
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .feedScene
    
    // 5.
    func start() {
        showHomeFeedView()
    }
    
    // Protocol Method
    func showHomeFeedView() {
        let reactor = HomeFeedReactor(homeFeedUseCase: HomeFeedUseCase(HomeFeedRepository()))
        
        reactor.didSendEventClosure = { [weak self] event in
            switch event {
            case .showFriendListView:
                self?.showFriendListView()

            case .showLikeUserListView(let feedId):
                self?.showLikeUserListView(feedId: feedId)
            }
        }
        
        let vc = HomeFeedViewController(reactor: reactor)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showLikeUserListView(feedId: Int) {
        let vc = LikeUserListViewController(
            reactor: LikeUserListReactor(
                LikeUserListUseCase(LikeUserListRepository()),
                feedId: feedId
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFriendListView() {
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
extension FeedSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
