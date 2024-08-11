//
//  TabbarViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TabbarViewController: UITabBarController {
    // MARK: - Properties
    
    
    private let homeReactor = HomeCalendarReactor()
    private lazy var homeVC = HomeCalendarViewController(reactor: homeReactor)
    
    private let feedVC = UIViewController()
    
    private let checkVC = UIViewController()
    
    private let myPageVC = MyPageViewController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        setTabBar()
        addNavigationBarViewControllers()
    }
}

// MARK: - NavigationBar(TabBar) 관련 설정

extension TabbarViewController {
    private func setTabBar() {
        tabBar.isTranslucent = true
        tabBar.tintColor = .tnOrange
        tabBar.unselectedItemTintColor = .grey05
        tabBar.backgroundColor = .white
    }
    
    private func addNavigationBarViewControllers() {
        let homeTab = createViewController(title: "캘린더", imageName: "boardTab", viewController: homeVC)
        let feedTab = createViewController(title: "피드", imageName: "calendarTab", viewController: feedVC)
        let checkTab = createViewController(title: "출석체크", imageName: "bellTab", viewController: checkVC)
        let myPageTab = createViewController(title: "마이페이지", imageName: "userTab", viewController: myPageVC)
        
        viewControllers = [homeTab, feedTab, checkTab, myPageTab]
    }
    
    private func createViewController(title: String?, imageName: String, viewController: UIViewController, isEnabled: Bool = true) -> UIViewController {
        let nav = UINavigationController(rootViewController: viewController)
        let image = UIImage(named: imageName)
        
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        nav.tabBarItem.isEnabled = isEnabled
        
        return nav
    }
}
