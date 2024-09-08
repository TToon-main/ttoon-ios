//
//  FriendTabViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import Pageboy
import RxSwift
import Tabman
import UIKit


class FriendTabViewController: TabmanViewController {
    // 탭맨 뷰컨은 따로 뷰모델이 없기 때문에 VC에 didSendEventClosure 추가
    var didSendEventClosure: ((FriendTabViewController.Event) -> Void)?
    
    var disposeBag = DisposeBag()
    
//    let friendListVC = FriendListViewController(reactor: FriendListReactor())
    let friendListVC = FriendListViewController(reactor: FriendListReactor(FriendListUseCase(FriendListRepository())))
    let friendRequestVC = ReceivedFriendRequestViewController(reactor: ReceivedFriendRequestReactor(ReceivedFriendRequestUseCase(ReceivedFriendRequestRepository())))
    
    private lazy var vcs = [friendListVC, friendRequestVC]
    
    let customContainer = UIView()  // Bar를 담고 있는 커스텀 뷰
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        settingNavigation()
        settingTabman()
    }
}


extension FriendTabViewController {
    private func settingNavigation() {
        // 타이틀
        navigationItem.title = "내 친구 목록"
        navigationItem.titleView?.backgroundColor = .white
        
        // 오른쪽 버튼 (친구 추가 화면 이동)
        let goSearchFriendButton = UIBarButtonItem(image: TNImage.homeNavigationFriendList, menu: nil)
        goSearchFriendButton.tintColor = .black
        goSearchFriendButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.didSendEventClosure?(.showSearchFriendView)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = goSearchFriendButton
    }
    
    
    private func settingTabman() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20
        
        bar.backgroundView.style = .flat(color: .white)
        
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .tnOrange
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.cornerStyle = .eliptical
        
        bar.buttons.customize { button in
            button.tintColor = .grey05
            button.selectedTintColor = .tnOrange
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
}


extension FriendTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 2
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: (index == 0) ? "친구 목록" : "친구 요청")
    }
}

extension FriendTabViewController {
    enum Event {
        case showSearchFriendView
    }
}
