//
//  SearchFriendViewController.swift
//  TTOON
//
//  Created by 임승섭 on 9/4/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class SearchFriendViewController: BaseViewController, View  {
    var disposeBag = DisposeBag()
    
    let mainView = SearchFriendView()
    
    init(reactor: SearchFriendReactor) {
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
        
        reactor?.action.onNext(.searchUserList("hi"))
        setNavigation()
    }
}

// MARK: - ReactorKit
extension SearchFriendViewController {
    func bind(reactor: SearchFriendReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    
    func bindAction(reactor: SearchFriendReactor) {
    }
    
    func bindState(reactor: SearchFriendReactor) {
        reactor.state.map { $0.searchedUserList }
            .bind(to: mainView.userTableView.rx.items(
                cellIdentifier: UserListTableViewCell.description(),
                cellType: UserListTableViewCell.self
            )) { row, user, cell in
                cell.profileInfoView.profileNicknameLabel.text = String(user.id)
                
                if row % 5 == 0 {
                    cell.requestFriendButton.type = .sendRequest
                } else if row % 3 == 0 {
                    cell.requestFriendButton.type = .sentRequest
                } else {
                    cell.requestFriendButton.type = .alreadyFriend
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: private func
extension SearchFriendViewController {
    private func setNavigation() {
        self.navigationItem.title = "친구 추가"
    }
}
