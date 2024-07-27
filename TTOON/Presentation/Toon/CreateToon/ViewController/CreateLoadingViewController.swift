//
//  CreateLoadingViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CreateLoadingViewController: BaseViewController {
    var disposeBag = DisposeBag()
    
    private let viewLifeCycle = PublishSubject<CreateLoadingReactor.Action>()
    private let createLoadingView = CreateLoadingView()
    
    init(reactor: CreateLoadingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = createLoadingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLifeCycle.onNext(.viewLifeCycle(cycle: .viewWillAppear))
    }
}

extension CreateLoadingViewController: View {
    func bind(reactor: CreateLoadingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CreateLoadingReactor) {
        viewLifeCycle
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CreateLoadingReactor) {
        reactor.state
            .map { $0.currentProgress }
            .bind(to: createLoadingView.rx.currentProgress)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.completeProgress }
            .compactMap { $0 }
            .bind(onNext: presentCreateResultVC)
            .disposed(by: disposeBag)
    }
    
    func presentCreateResultVC() {
        let vc = CreateResultViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
