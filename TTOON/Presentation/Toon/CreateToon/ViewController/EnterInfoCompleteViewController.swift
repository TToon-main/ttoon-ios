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
        bind()
    }
    
    private func bind() {
        enterInfoCompleteView.rx.confirmButtonTap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
