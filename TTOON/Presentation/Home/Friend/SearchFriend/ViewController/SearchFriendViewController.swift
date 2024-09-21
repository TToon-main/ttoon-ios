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
        
        setNavigation()
        setSearchBar()
    }
}

// MARK: - ReactorKit
extension SearchFriendViewController {
    func bind(reactor: SearchFriendReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    
    func bindAction(reactor: SearchFriendReactor) {
        // searchBar 버튼 액션은 delegate 이용
        
        // pagination
        mainView.userTableView.rx.prefetchRows
            .subscribe(with: self) { owner, indexPaths in
                let itemCnt = self.mainView.userTableView.numberOfRows(inSection: 0)
                
                if indexPaths.contains(where: {
                    $0.row == itemCnt - 3
                }) {
                    print("pagination 진행!")
                    reactor.action.onNext(.loadNextList)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SearchFriendReactor) {
        // tableView
        reactor.state.map { $0.searchedUserList }
            .bind(to: mainView.userTableView.rx.items(
                cellIdentifier: UserListTableViewCell.description(),
                cellType: UserListTableViewCell.self
            )) { row, user, cell in
                cell.setDesign(user.userInfo)
                
                switch user.status {
                case .accept:   // 이미 친구 상태
                    cell.requestFriendButton.type = .alreadyFriend  // 나의 친구
                    
                case .nothing, .asking:  // 아무런 연관 없는 상태 or 상대방이 요청 보낸 상태
                    cell.requestFriendButton.type = .sendRequest    // 친구 신청
                    
                case .waiting:  // 내가 이미 친구 요청을 보낸 상태
                    cell.requestFriendButton.type = .sentRequest    // 요청됨
                }
                
                
                cell.requestFriendButton.rx.tap
                    .map { SearchFriendReactor.Action.requestFriend(user.userInfo.nickname) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchedUserList }
            .subscribe(with: self) { owner, list  in
                owner.mainView.showNoDataView(show: list.isEmpty)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchFriendViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        reactor?.action.onNext(.searchUserList(searchText))
        searchBar.resignFirstResponder()
        
        // 같은 텍스트 입력 시 콜 x 로직?
    }
}

// MARK: private func
extension SearchFriendViewController {
    private func setNavigation() {
        self.navigationItem.title = "친구 추가"
    }
    private func setSearchBar() {
        mainView.searchBar.delegate = self
    }
}
