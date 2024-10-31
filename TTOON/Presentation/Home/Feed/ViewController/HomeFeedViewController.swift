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
        ttoonNavigationView.friendListButton.rx.tap
            .map { HomeFeedReactor.Action.friendListButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
                
                // 좋아요 리스트
                cell.likeNumberButton.rx.tap
                    .map { HomeFeedReactor.Action.showLikeUserListVC(feedId: feedModel.id) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                // 메뉴 버튼
                cell.menuClearButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        // 1. reactor에 selected Feed ID 지정
                        reactor.action.onNext(.showMenuBottomSheetVC(feedId: feedModel.id))
                        
                        // 2. 바텀 시트 띄우기
                        owner.presentFeedDetailMenuBottomSheetVC(feedId: feedModel.id)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Feed Detail Menu Delegate
extension HomeFeedViewController: FeedDetailMenuBottomSheetActionProtocol {
    func firstButtonTapped() {
        TNAlert(self)
            .setTitle("만화를 어떻게 저장하시겠어요?\n")
            .addCancelAction("네 컷을 따로") {
                self.reactor?.action.onNext(.saveTToonImage(.fourPage))
                print("네 컷")
            }
            .addConfirmAction("한 장으로") {
                self.reactor?.action.onNext(.saveTToonImage(.onePage))
                print("한 장")
            }
            .present()
    }
    
    func secondButtonTapped() {
        TNAlert(self)
            .setTitle("만화를 어떻게 공유하시겠어요?")
            .addCancelAction("네 컷을 따로") {
                self.reactor?.action.onNext(.shareTToonImage(.fourPage))
                print("네 컷")
            }
            .addConfirmAction("한 장으로") {
                self.reactor?.action.onNext(.shareTToonImage(.onePage))
                print("한 장")
            }
            .present()
    }
    
    func thirdButtonTapped() {
        // VC에서는 세번째 버튼이 탭 되었다는 액션만 전달하고,
        // 삭제할건지 신고할건지는 reactor에서 결정한다. (state.selectedFeed 확인하면 됨)
        
        // * 10/11 수정
        // 팝업이 있기 때문에, 여기서 삭제할지 신고할지 알아야 함.
        
        if let isMine = self.reactor?.isMine(feedId: self.reactor?.currentState.selectedFeedForMenu ?? -1), isMine {
            // 삭제하기 바텀시트
            let feedDate = self.reactor?.dateOfFeed(feedId: self.reactor?.currentState.selectedFeedForMenu ?? -1)
            self.presentDeleteFeedPopUpBottomSheetVC(feedDate)
        } else {
            // 신고하기 팝업
            let userName = self.reactor?.userNameOfFeed(feedId: self.reactor?.currentState.selectedFeedForMenu ?? -1) ?? ""
            TNAlert(self)
                .setTitle("정말 신고하시겠어요?")
                .setSubTitle("\(userName)님의\n게시글을 신고해요")
                .addCancelAction("취소") {
                }
                .addConfirmAction("신고하기") {
                    self.reactor?.action.onNext(.deleteOrReport)
                }
                .present()
        }
    }
}

// MARK: - Delete Friend Bottom Sheet
extension HomeFeedViewController: PopUpBotttomSheetActionProtocol {
    func confirmButtonTapped() {
        print("삭제")
        self.reactor?.action.onNext(.deleteOrReport)
    }
    
    func cancelButtonTapped() {
        print("취소")
    }
}


// private func
extension HomeFeedViewController {
    private func loadFirstData() {
        let onlyMyFeed = UserDefaultsManager.onlyMyFeed
        mainView.setSwitch(onlyMyFeed)
        self.reactor?.action.onNext(.loadFirstData(onlyMyFeed))
    }
    
    // 디테일 옵션 바텀시트
    private func presentFeedDetailMenuBottomSheetVC(feedId: Int) {
        // 내가 만든 피드인지 확인
        let isMine = reactor?.isMine(feedId: feedId) ?? false
        
        let vc = FeedDetailMenuBottomSheetViewController()
        
        vc.delegate = self
        
        vc.menuView.setText(
            first: "이미지 저장하기",
            second: "공유하기",
            third: isMine ? "삭제하기" : "신고하기"
        )
        
        if let sheet = vc.sheetPresentationController {
            // 15 * 2 + 60 * 3 + 2
            sheet.detents = [.custom { _ in return 212 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated: true)
    }
    
    // 피드 삭제 바텀시트
    private func presentDeleteFeedPopUpBottomSheetVC(_ feedDate: String?) {
        // 인풋 형식 : 0000-00-00
        if let date = feedDate?.toDate(to: .fullWithHyphen)?.toString(of: .fullKorean) {
            let vc = FriendListPopUpBottomSheetViewController(
               title: "\(date)의 기록을\n삭제하시겠어요?",
                subTitle: "기록을 삭제하면, 나중에 내용과\n네컷 만화 모두 다시 복구할 수 없어요",
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
}
