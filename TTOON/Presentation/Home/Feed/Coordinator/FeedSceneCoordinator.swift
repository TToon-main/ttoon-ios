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
}
class FeedSceneCoordinator: FeedSceneCoordinatorProtocol {
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
    var type: CoordinatorType = .feedScene
    
    // 5.
    func start() {
        print("start FeedSceneCoordinator")
        
        showHomeFeedView()
    }
    
    // Protocol Method
    func showHomeFeedView() {
        let reactor = HomeFeedReactor(homeFeedUseCase: HomeFeedUseCase(HomeFeedRepository()))
        
        reactor.didSendEventClosure = { [weak self] event in
            switch event {
            case .showFriendListView:
                print("showFriendListView")

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
}
extension FeedSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
