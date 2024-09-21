//
//  FriendRequestViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class ReceivedFriendRequestViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let mainView = ReceivedFriendRequestView()
    
    init(reactor: ReceivedFriendRequestReactor) {
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
extension ReceivedFriendRequestViewController {
    func bind(reactor: ReceivedFriendRequestReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ReceivedFriendRequestReactor) {
        // pagination
        mainView.receivedRequestListTableView.rx.prefetchRows
            .subscribe(with: self) { owner, indexPaths  in
                let itemCnt = self.mainView.receivedRequestListTableView.numberOfRows(inSection: 0)
                
                print("prefetch : itemCnt : \(itemCnt) indexPaths : \(indexPaths)")
                
                if indexPaths.contains(where: { $0.row == itemCnt - 3 }) {
                    print("pagination 진행!")
                    reactor.action.onNext(.loadNextList)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: ReceivedFriendRequestReactor) {
        reactor.state.map { $0.receivedRequestList }
            .bind(to: mainView.receivedRequestListTableView.rx.items(
                cellIdentifier: ReceivedFriendRequestTableViewCell.description(),
                cellType: ReceivedFriendRequestTableViewCell.self)) { row, user, cell in
                    cell.setDesign(user)
                
                    cell.acceptButton.rx.tap
                            .map { ReceivedFriendRequestReactor.Action.acceptRequest(user.friendId) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    cell.rejectButton.rx.tap
                        .map { ReceivedFriendRequestReactor.Action.rejectRequest(user.friendId) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.receivedRequestList }
            .subscribe(with: self) { owner, list  in
                owner.mainView.showNoDataView(show: list.isEmpty)
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - private func
extension ReceivedFriendRequestViewController {
    private func loadData() {
        reactor?.action.onNext(.loadReceivedRequestList)
    }
    
    private func setNavigation() {
        self.navigationItem.title = "받은 요청"
    }
}
