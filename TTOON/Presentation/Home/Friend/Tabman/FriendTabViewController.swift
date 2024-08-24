//
//  FriendTabViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import Pageboy
import Tabman
import UIKit



class FriendTabViewController: TabmanViewController {
    let friendListVC = FriendListViewController(reactor: FriendListReactor())
    let friendRequestVC = FriendRequestViewController()
    
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
        navigationItem.title = "내 친구 목록"
        navigationItem.titleView?.backgroundColor = .white
    }
    
//    // 그냥 탭을 올리면 네비게이션 영역이 안보이는 이슈가 있어, Custom Container 이용하는 방식 채택
//    private func settingCustomContainer() {
//        customContainer.backgroundColor = .clear
//        
//        view.addSubview(customContainer)
//        customContainer.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(46)
//        }
//    }
    
    
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
        
//        addBar(bar, dataSource: self, at: .custom(view: customContainer, layout: nil))
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
