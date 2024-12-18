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
    private let selectedCharacters = PublishSubject<[CharacterPickerTableViewCellDataSource]>()
    
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
    
    override func configures() {
        super.configures()
        setNavigationItem(title: "기록 추가하기")
    }
}

extension EnterInfoViewController: View {
    func bind(reactor: EnterInfoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EnterInfoReactor) {
        enterInfoScrollView.rx.dairyTextView1DidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.dairyTextView2DidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.dairyTextView3DidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.dairyTextView4DidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.selectCharactersButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.confirmButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx.titleTextFieldTextDidChange
            .map{ EnterInfoReactor.Action.titleTextFieldTextDidChange($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EnterInfoReactor) {
        reactor.state
            .compactMap { $0.presentCharacterPickerBS }
            .bind(onNext: presentCharacterPickerBS)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.presentCreateLoadingVC }
            .bind(onNext: presentCreateLoadingVC)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.presentModifyCharacterVC }
            .bind(onNext: presentModifyCharacterVC)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentProgress }
            .distinctUntilChanged()
            .skip(1)
            .bind(to: rx.currentProgress)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.characterButtonText }
            .bind(to: enterInfoScrollView.rx.characterButtonText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.titleTextFieldError }
            .distinctUntilChanged()
            .bind(to: enterInfoScrollView.rx.titleTextFiledError)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dairyTextView1Error }
            .distinctUntilChanged()
            .bind(to: enterInfoScrollView.rx.dairyTextView1Error)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.dairyTextView1TextCount }
            .bind(to: enterInfoScrollView.rx.dairyTextView1TextCount)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dairyTextView2Error }
            .distinctUntilChanged()
            .bind(to: enterInfoScrollView.rx.dairyTextView1Error)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.dairyTextView2TextCount }
            .bind(to: enterInfoScrollView.rx.dairyTextView2TextCount)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dairyTextView3Error }
            .distinctUntilChanged()
            .bind(to: enterInfoScrollView.rx.dairyTextView1Error)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.dairyTextView3TextCount }
            .bind(to: enterInfoScrollView.rx.dairyTextView3TextCount)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dairyTextView4Error }
            .distinctUntilChanged()
            .bind(to: enterInfoScrollView.rx.dairyTextView1Error)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.dairyTextView4TextCount }
            .bind(to: enterInfoScrollView.rx.dairyTextView4TextCount)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.titleTextFieldTextCount }
            .bind(to: enterInfoScrollView.rx.titleTextFieldTextCount)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: enterInfoScrollView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.presentEnterInfoCompleteVC }
            .bind(onNext: presentEnterInfoCompleteVC)
            .disposed(by: disposeBag)
    }
}

extension EnterInfoViewController: CharacterPickerBSDelegate {
    func selectedCharacters(selectedModels: [CharacterPickerTableViewCellDataSource]) {
        self.reactor?.action.onNext(.characterSelected(models: selectedModels))
    }
    
    func presentModifyCharacterViewController() {
        self.reactor?.action.onNext(.presentModifyCharacterVC)
    }
}

// MARK: - 화면 전환

extension EnterInfoViewController {
    private func presentCreateLoadingVC() {
        // TODO: - 임시로 화면
        let vc = CreateResultViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentCharacterPickerBS() {
        let repo = ToonRepository()
        let useCase = ToonUseCase(repo: repo)
        let reactor = CharacterPickerBSReactor(useCase: useCase)
        reactor.delegate = self
        
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
    
    private func presentModifyCharacterVC() {
        let repo = ToonRepository()
        let useCase = ToonUseCase(repo: repo)
        let reactor = CharacterModifyReactor(useCase: useCase)
        let vc = CharacterModifyViewController(reactor: reactor)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentEnterInfoCompleteVC(_ flag: Bool) {
        if flag {
            let vc = EnterInfoCompleteViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
