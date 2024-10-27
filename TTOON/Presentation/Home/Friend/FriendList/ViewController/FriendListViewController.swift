//
//  FriendListViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

 import ReactorKit
 import RxCocoa
 import RxSwift
 import UIKit

 class FriendListViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let mainView = FriendListView()
    
    init(reactor: FriendListReactor) {
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
        
//        presentIntroductionAddFriendPopUpView()
    }
}

// MARK: - ReactorKit bind
 extension FriendListViewController {
    func bind(reactor: FriendListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: FriendListReactor) {
        // pagination
        mainView.friendListTableView.rx.prefetchRows
            .subscribe(with: self) { owner, indexPaths in
                // n-1번째 셀을 로드할 때, pagination 액션 전달
                let itemCnt = owner.mainView.friendListTableView.numberOfRows(inSection: 0)
                
                print("prefetch : itemCnt : \(itemCnt) indexPaths : \(indexPaths)")
                
                if indexPaths.contains(where: { $0.row == itemCnt - 3 }) {
                    print("pagination 진행!")
                    reactor.action.onNext(.loadNextFriendList)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: FriendListReactor) {
        reactor.state.map { $0.friendList }
            .bind(to: mainView.friendListTableView.rx.items(cellIdentifier: FriendListTableViewCell.description(), cellType: FriendListTableViewCell.self)) { row, user, cell in
                cell.setDesign(user)
                
                cell.deleteFriendButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        // 1. reactor에 selected friend id 지정
                        reactor.action.onNext(.showBottomSheetVC(friendID: user.friendId))
                        
                        // 2. 바텀 시트 띄우기
                        owner.presentConfirmFriendDeletionPopupView(user)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.friendList }
            .subscribe(with: self) { owner, list in
                owner.mainView.showNoFriendView(show: list.isEmpty)
            }
            .disposed(by: disposeBag)
    }
 }


extension FriendListViewController: PopUpBotttomSheetActionProtocol {
    func confirmButtonTapped() {
        self.reactor?.action.onNext(.deleteFriend)
    }
    
    func cancelButtonTapped() {
        print("취소")
    }
}

// MARK: - private func
extension FriendListViewController {
    private func loadData() {
        reactor?.action.onNext(.loadInitialFriendList)
    }
     
    private func setNavigation() {
        self.navigationItem.title = "친구 목록"
    }
     
    // 친구 삭제 시도시, "'000'님과 친구를 끊으시겠어요?" 팝업을 보여준다.
    private func presentConfirmFriendDeletionPopupView(_ model: UserInfoModel) {
         let vc = FriendListPopUpBottomSheetViewController(
            title: "\(model.nickname)님과\n친구를 끊으시겠어요?",
             subTitle: "친구를 삭제하면, 이제 친구의 기록을\n볼 수 없게 되어요",
             image: TNImage.characterDeleteIcon!,
             confirmButtonTitle: "삭제할래요",
             cancelButtonTitle: "돌아가기"
         )
        
        vc.delegate = self
         
         if let sheet = vc.sheetPresentationController {
             sheet.detents = [.custom { _ in return 368 } ]
             sheet.prefersGrabberVisible = true
             sheet.prefersScrollingExpandsWhenScrolledToEdge = false
             sheet.prefersEdgeAttachedInCompactHeight = true
             sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
         }
         
         present(vc, animated: true, completion: nil)
     }
 }
