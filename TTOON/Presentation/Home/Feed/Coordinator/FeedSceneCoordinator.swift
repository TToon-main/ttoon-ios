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
        let vc = HomeFeedViewController(reactor: HomeFeedReactor(homeFeedUseCase: HomeFeedUseCase()))
        navigationController.pushViewController(vc, animated: true)
    }
}
extension FeedSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
