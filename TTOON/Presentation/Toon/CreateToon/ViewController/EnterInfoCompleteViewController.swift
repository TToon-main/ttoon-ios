//
//  EnterInfoCompleteViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/3/24.
//

import UIKit

import RxSwift

class EnterInfoCompleteViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let enterInfoCompleteView = EnterInfoCompleteView()
    
    override func loadView() {
        view = enterInfoCompleteView
    }
    
    override func configures() {
        super.configures()
        self.navigationController?.navigationBar.isHidden = true
        bind()
    }
    
    private func bind() {
        enterInfoCompleteView.rx.confirmButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.popViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func popViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
