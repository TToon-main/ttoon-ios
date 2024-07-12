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
    }
    
    func bindState(reactor: EnterInfoReactor) {
        reactor.state
            .map { $0.validTextFieldText }
            .bind(to: enterInfoScrollView.rx.validTextFieldText)
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        enterInfoView.confirmButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = CreateLoadingViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
