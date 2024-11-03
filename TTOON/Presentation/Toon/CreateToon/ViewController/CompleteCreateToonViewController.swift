//
//  CompleteCreateToonViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/3/24.
//

import UIKit

import RxSwift

class CompleteCreateToonViewController: BaseViewController {
    var disposeBag = DisposeBag()
    var didSendEventClosure: ((CompleteCreateToonViewController.Event) -> Void)?
    private let urls: [String]
    
    enum Event {
        case showCompleteToonView(urls: [String])
    }
    
    private let completeCreateToonView = CompleteCreateToonView()
    
    init(urls: [String]) {
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = completeCreateToonView
    }
    
    override func configures() {
        super.configures()
        self.navigationController?.navigationBar.isHidden = true
        bind()
    }
    
    private func bind() {
        completeCreateToonView.rx.confirmButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.didSendEventClosure?(.showCompleteToonView(urls: owner.urls))
            })
            .disposed(by: disposeBag)
    }
}
