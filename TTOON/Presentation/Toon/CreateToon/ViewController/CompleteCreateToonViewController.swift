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
    private let model: SaveToon
    
    enum Event {
        case showCompleteToonView(model: SaveToon)
    }
    
    private let completeCreateToonView = CompleteCreateToonView()
    
    init(model: SaveToon) {
        self.model = model
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
        navigationItem.backButtonTitle = ""
        bind()
    }
    
    private func bind() {
        completeCreateToonView.rx.confirmButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.didSendEventClosure?(.showCompleteToonView(model: owner.model))
            })
            .disposed(by: disposeBag)
    }
}
