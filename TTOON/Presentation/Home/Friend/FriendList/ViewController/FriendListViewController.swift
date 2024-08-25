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
        
        sampleLogic()
    }
     
     
     // sample
     func sampleLogic() {
         mainView.button1.addTarget(self, action: #selector(presentIntroductionAddFriendPopUpView), for: .touchUpInside)
         mainView.button2.addTarget(self, action: #selector(presentConfirmFriendDeletionPopupView), for: .touchUpInside)
     }
 }


// MARK: - ReactorKit bind
 extension FriendListViewController {
    func bind(reactor: FriendListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: FriendListReactor) {
    }
    
    func bindState(reactor: FriendListReactor) {
    }
 }


// MARK: - private func
 extension FriendListViewController {
    private func setNavigation() {
        self.navigationItem.title = "친구 목록"
    }
    
    // 맨 처음 들어온 경우, "닉네임 검색으로 친구 추가하기" 팝업을 보여준다.
    @objc private func presentIntroductionAddFriendPopUpView() {
        let vc = FriendListPopUpBottomSheetViewController(
            title: "닉네임 검색으로 친구 추가하기",
            subTitle: "친구를 추가하면 친구와 서로의 기록을\n살펴보고 반응해줄 수 있어요",
            image: TNImage.highFive_color!,
            confirmButtonTitle: "친구 추가하러 가기",
            cancelButtonTitle: nil
        )
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 368 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated: true, completion: nil)
    }
     
     // 친구 삭제 시도 시, "'000'님과 친구를 끊으시겠어요?" 팝업을 보여준다.
     @objc private func presentConfirmFriendDeletionPopupView() {
         let vc = FriendListPopUpBottomSheetViewController(
             title: "'000'님과\n친구를 끊으시겠어요?",
             subTitle: "친구를 삭제하면, 이제 친구의 기록을\n볼 수 없게 되어요",
             image: TNImage.characterDeleteIcon!,
             confirmButtonTitle: "삭제할래요",
             cancelButtonTitle: "돌아가기"
         )
         
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
