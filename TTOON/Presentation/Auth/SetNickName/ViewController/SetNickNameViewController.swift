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
    private let setNickNameView = SetNickNameView()
    
    // MARK: - Initializer
    
    init(setNickNameReactor: SetNickNameReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = setNickNameReactor 
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = setNickNameView
    }
}

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
    }
    
    func bindState(reactor: SetNickNameReactor) {
        reactor.state.map { $0.focusTextField }
            .distinctUntilChanged()
            .bind(to: setNickNameView.rx.isFocusTextField)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.text }
            .bind(to: setNickNameView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.textFieldStatus }
            .bind(to: setNickNameView.rx.isValidText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: setNickNameView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
    }
}
