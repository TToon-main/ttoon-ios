//
//  LikeUserViewController.swift
//  TTOON
//
//  Created by 임승섭 on 10/28/24.
//

import ReactorKit
import RxSwift
import UIKit

class LikeUserListViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let mainView = LikeUserListView()
    
    init(reactor: LikeUserListReactor) {
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
        
        setNavigation()
        loadData()
    }
}

// MARK: - ReactorKit
extension LikeUserListViewController {
    func bind(reactor: LikeUserListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: LikeUserListReactor) {
    }
    
    private func bindState(reactor: LikeUserListReactor) {
        reactor.state.map { $0.likeUserList }
            .bind(to: mainView.likeUserListTableView.rx.items(cellIdentifier: LikeUserListTableViewCell.description(), cellType: LikeUserListTableViewCell.self)) { row, user, cell in
                cell.setDesign(user)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.likeUserList }
            .subscribe(with: self) { owner, list  in
                owner.mainView.showNoLikesView(show: list.isEmpty)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - private func
extension LikeUserListViewController {
    private func loadData() {
        reactor?.action.onNext(.loadData)
    }
    
    private func setNavigation() {
        self.navigationItem.title = "좋아요 목록"
    }
}
