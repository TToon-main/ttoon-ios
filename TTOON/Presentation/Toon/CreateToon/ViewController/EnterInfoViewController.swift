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
    private let presentModifyCharacterVCAction = PublishSubject<EnterInfoReactor.Action>() 
    private let viewLifeCycle = PublishSubject<EnterInfoReactor.Action>()
    
    override func loadView() {
        view = enterInfoScrollView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLifeCycle.onNext(.viewLifeCycle(.viewWillAppear))
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
        viewLifeCycle
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        presentModifyCharacterVCAction
            .asObservable()
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
        
        reactor.state
            .map { $0.presentModifyCharacterVC }
            .compactMap{ $0 }
            .bind(onNext: presentModifyCharacterVC)
            .disposed(by: disposeBag)
    }
    
    private func presentCreateLoadingVC() {
        // TODO: - 임시로 화면 
//        let reactor = CreateLoadingReactor()
//        let vc = CreateLoadingViewController(reactor: reactor)
        
        let vc = CreateResultViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentCharacterPickerBS() {
        let reactor = CharacterPickerBSReactor()
        let viewControllerToPresent = CharacterPickerBSViewController(reactor: reactor)
        viewControllerToPresent.delegate = self
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.custom { context in return 583 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func presentModifyCharacterVC() {
        let reactor = CharacterModifyReactor()
        let vc = CharacterModifyViewController(reactor: reactor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EnterInfoViewController: PresentModifyCharacterVCDelegate {
    func presentModifyCharacterViewController() {
        self.presentModifyCharacterVCAction.onNext(.presentModifyCharacterVC)
    }
}
