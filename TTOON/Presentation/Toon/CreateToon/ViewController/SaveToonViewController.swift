//
//  SaveToonViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/13/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class SaveToonViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let completeToonScrollView = CompleteToonScrollView()
    
    init(reactor: SaveToonReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configures() {
        super.configures()
        view.backgroundColor = .white
        completeToonScrollView.completeToonView.setUpView(isCompleted: true)
        
        navigationItem.title = "네컷만화 완성하기"
        navigationItem.backButtonTitle = ""
    }
    
    override func layouts() {
        super.layouts()
        view.addSubview(completeToonScrollView)
        
        completeToonScrollView.snp.makeConstraints {
            $0.edges.equalTo(safeGuide)
        }
    }
}

extension SaveToonViewController: View {
    func bind(reactor: SaveToonReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SaveToonReactor) {
        rx.viewDidLoad
            .map { SaveToonReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        completeToonScrollView.rx.confirmButtonTap
            .map { SaveToonReactor.Action.confirmButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SaveToonReactor) {
        reactor.state.compactMap { $0.list }
            .map { $0.map { $0.imageUrl } }
            .bind(to: completeToonScrollView.rx.selectedUrls)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessSave }
            .bind { [weak self] isSuccess in
                if isSuccess {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
