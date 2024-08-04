//
//  CreateResultViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import RxSwift

class CreateResultViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let createResultView = CreateResultView()
    
    override func loadView() {
        view = createResultView
    }
    
    override func bind() {
        createResultView.rx.confirmButtonTap
            .bind(onNext: presentCompleteToonVC)
            .disposed(by: disposeBag)
    }
    
    func presentCompleteToonVC() {
        let reactor = CompleteToonReactor()
        let vc = CompleteToonViewController(reactor: reactor)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
