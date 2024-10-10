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
    
    var isPrefetchingEnabled = true
    var preventPagination = false

    
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
        
        print("token : \(KeychainStorage.shared.accessToken)")
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

        
        // prefetchRows 함수를 이용하면 tableViewCell 내의 collectionView를 스크롤할 때도 계속 실행되는 이슈 발생
        // -> 스크롤 offset으로 pagination 구현
        // 스크롤이 끝에 도달했을 때 페이지네이션 트리거
        mainView.feedTableView.rx.reachedBottom(offset: 100)
            .subscribe(with: self) { owner, value in
                reactor.action.onNext(.loadNextFeedList)
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: HomeFeedReactor) {
        reactor.state.map { $0.feedList }
            .bind(to: mainView.feedTableView.rx.items(cellIdentifier: FeedTableViewCell.description(), cellType: FeedTableViewCell.self)) { row, feedModel, cell in
                cell.feedModel = feedModel
                cell.setDesign()
                
                // 좋아요
                cell.likeButton.rx.tap
                    .map { HomeFeedReactor.Action.likeButtonTapped(feedId: feedModel.id) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
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
