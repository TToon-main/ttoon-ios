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
    
    override func addSubViews() {
        super.addSubViews()
        view.addSubview(scrollView)
        scrollView.addSubview(enterInfoView)
    func bindAction(reactor: EnterInfoReactor) {
        enterInfoScrollView.rx
            .textFieldDidChange
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        enterInfoScrollView.rx
            .confirmButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func configures() {
        super.configures()
        view.backgroundColor = .white
    func bindState(reactor: EnterInfoReactor) {
        reactor.state
            .map { $0.validTextFieldText }
            .bind(to: enterInfoScrollView.rx.validTextFieldText)
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
}
