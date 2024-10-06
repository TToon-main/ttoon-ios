//
//  HomeFeedViewController.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class HomeFeedViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    // UI
    let mainView = HomeFeedView()
    let ttoonNavigationView = TToonLogHomeNavigationView()

    
    init(reactor: HomeFeedReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        setCustomNavigationBar(ttoonNavigationView)
        
        // Logic
        loadFirstData()
    }
}


// bind
extension HomeFeedViewController {
    func bind(reactor: HomeFeedReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: HomeFeedReactor) {
        // switch
        mainView.onlyMyFeedView.onlyMyFeedSwitch.rx.isOn
            .map { HomeFeedReactor.Action.loadFirstData($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: HomeFeedReactor) {
        reactor.state.map { $0.feedList }
            .bind(to: mainView.feedTableView.rx.items(cellIdentifier: FeedTableViewCell.description(), cellType: FeedTableViewCell.self)) { row, feedModel, cell in
                cell.setDesign(feedModel)
            }
            .disposed(by: disposeBag)
    }
}


// private func
extension HomeFeedViewController {
    private func loadFirstData() {
        let onlyMyFeed = UserDefaultsManager.onlyMyFeed
        mainView.setSwitch(onlyMyFeed)
        self.reactor?.action.onNext(.loadFirstData(onlyMyFeed))
    }
}
