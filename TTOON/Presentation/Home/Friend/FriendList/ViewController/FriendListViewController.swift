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
        presentCharacterPickerBS()
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
    private func presentCharacterPickerBS() {
//        let reactor = CharacterPickerBSReactor()
        let vc = FriendListPopUpBottomSheetViewController()
//        let viewControllerToPresent = CharacterPickerBSViewController(reactor: reactor)
//        viewControllerToPresent.delegate = self
        
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
