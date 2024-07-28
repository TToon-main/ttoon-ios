//
//  EnterInfoViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class EnterInfoViewController: CreateToonBaseViewController {
    var disposeBag = DisposeBag()
    private let enterInfoScrollView = EnterInfoScrollView()
    
    override func loadView() {
        view = enterInfoScrollView
    }
    
    init(reactor: EnterInfoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EnterInfoViewController: View {
    func bind(reactor: EnterInfoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterInfoReactor) {
        enterInfoScrollView.rx
            .textFieldDidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx
            .selectCharactersButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx
            .confirmButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterInfoReactor) {
        reactor.state
            .map { $0.validTextFieldText }
            .bind(to: enterInfoScrollView.rx.validTextFieldText)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentCharacterPickerBS }
            .compactMap{ $0 }
            .bind(onNext: presentCharacterPickerBS)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentCreateLoadingVC }
            .compactMap{ $0 }
            .bind(onNext: presentCreateLoadingVC)
            .disposed(by: disposeBag)
    }
    
    private func presentCreateLoadingVC() {
        let reactor = CreateLoadingReactor()
        let vc = CreateLoadingViewController(reactor: reactor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentCharacterPickerBS() {
        let reactor = CharacterPickerBSReactor()
        let viewControllerToPresent = CharacterPickerBSViewController(reactor: reactor)
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.custom { context in return 583 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
