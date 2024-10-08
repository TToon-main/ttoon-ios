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
        mainView.feedTableView.rx.contentOffset
            .map { contentOffset in
                let offsetY = contentOffset.y
                let contentHeight = self.mainView.feedTableView.contentSize.height
                let frameHeight = self.mainView.feedTableView.frame.size.height
                
                return offsetY > contentHeight - frameHeight - 100
            }
            .subscribe(with: self) { owner, value in
                if value && !owner.reactor!.currentState.isDone {
                    print("pagination 진행")
                    reactor.action.onNext(.loadNextFeedList)
                    // isDone은 로드 끝나면 다시 false로 바꿔줌
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: HomeFeedReactor) {
        reactor.state.map { $0.feedList }
            .bind(to: mainView.feedTableView.rx.items(cellIdentifier: FeedTableViewCell.description(), cellType: FeedTableViewCell.self)) { row, feedModel, cell in
                // FeedTableViewCell에서 prefetch 활성화/비활성화 핸들러 설정
                cell.disablePrefetching = { [weak self] in
                    self?.isPrefetchingEnabled = false
                }
                cell.enablePrefetching = { [weak self] in
                    self?.isPrefetchingEnabled = true
                }
                
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
