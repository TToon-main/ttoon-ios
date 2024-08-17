//
//  AddFriendViewController.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class AddFriendViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let mainView = AddFriendView()
    
    init(reactor: AddFriendReactor) {
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
    }
}


// MARK: - ReactorKit bind
extension AddFriendViewController {
    func bind(reactor: AddFriendReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AddFriendReactor) {
    }
    
    func bindState(reactor: AddFriendReactor) {
    }
}


// MARK: - private func
extension AddFriendViewController {
    private func setNavigation() {
        self.navigationItem.title = "친구 목록"
    }
}
