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
    }
    
    func bindState(reactor: ReceivedFriendRequestReactor) {
        reactor.state.map { $0.receivedRequestList }
            .bind(to: mainView.receivedRequestListTableView.rx.items(
                cellIdentifier: ReceivedFriendRequestTableViewCell.description(),
                cellType: ReceivedFriendRequestTableViewCell.self)) { row, user, cell in
                cell.profileInfoView.profileNicknameLabel.text = String(user.id)
                
                cell.acceptButton.rx.tap
                    .map { ReceivedFriendRequestReactor.Action.acceptRequest(user.id) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.rejectButton.rx.tap
                    .map { ReceivedFriendRequestReactor.Action.rejectRequest(user.id) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
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
