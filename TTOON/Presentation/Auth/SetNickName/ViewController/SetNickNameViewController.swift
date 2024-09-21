//
//  SetNickNameViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class SetNickNameViewController: BaseViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var didSendEventClosure: ( (SetNickNameViewController.TransitionEvent) -> Void)?
    
    // MARK: - UI Properties
    
    private let setNickNameView = SetNickNameView()

    
    // MARK: - TransitionEvent
    
    enum TransitionEvent {
        case goTabBarFlow
    }
    
    // MARK: - Initializer
    
    init(setNickNameReactor: SetNickNameReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = setNickNameReactor 
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life Cycle
    
    override func loadView() {
        view = setNickNameView
    }
    
    // MARK: - Route Transition
    
    private func dismiss(_ flag: Bool) {
        if flag {
            self.dismiss(animated: true)
        }
    }
    
    private func toTabBar(_ flag: Bool) {
        let completion = { [weak self] in
            guard let self else { return }
            self.didSendEventClosure?(.goTabBarFlow)
        }
        
        if flag {
            self.dismiss(animated: true, completion: completion)
        }
    }
}

// MARK: - Bind actions, states

extension SetNickNameViewController: View {
    func bind(reactor: SetNickNameReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SetNickNameReactor) {
        setNickNameView.rx.textDidChanged
            .map { SetNickNameReactor.Action.textFiledText(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        setNickNameView.rx.confirmButtonTap
            .map { SetNickNameReactor.Action.confirmButtonTap(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        setNickNameView.rx.popButtonTap
            .map { SetNickNameReactor.Action.popButtonTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SetNickNameReactor) {
        reactor.state.map { $0.focusTextField }
            .distinctUntilChanged()
            .bind(to: setNickNameView.rx.isFocusTextField)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.text }
            .bind(to: setNickNameView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.setErrorMessage }
            .bind(to: setNickNameView.rx.setErrorMassage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: setNickNameView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dismiss }
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.toTabBar }
            .bind(onNext: self.toTabBar)
            .disposed(by: disposeBag)
    }
}
