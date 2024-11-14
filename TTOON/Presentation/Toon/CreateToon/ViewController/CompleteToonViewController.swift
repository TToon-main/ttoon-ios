//
//  CompleteToonViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CompleteToonViewController: CreateToonBaseViewController {
    var disposeBag = DisposeBag()
    private let completeToonScrollView = CompleteToonScrollView()
    
    init(reactor: CompleteToonReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = completeToonScrollView
    }
    
    
    override func configures() {
        super.configures()
        setNavigationItem(title: "네컷만화 완성하기")
        view.backgroundColor = .white
    }
    
//    override func layouts() {
//        super.layouts()
//        view.addSubview(completeToonScrollView)
//        
//        completeToonScrollView.snp.makeConstraints {
//            $0.top.equalTo(progressContainer.snp.bottom)
//            $0.bottom.horizontalEdges.equalToSuperview()
//        }
//    }
}

extension CompleteToonViewController: View {
    func bind(reactor: CompleteToonReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CompleteToonReactor) {
        rx.viewDidLoad
            .map { CompleteToonReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        completeToonScrollView.rx.selectedIndex
            .map { CompleteToonReactor.Action.selectedIndex($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        completeToonScrollView.rx.confirmButtonTap
            .map { CompleteToonReactor.Action.confirmButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CompleteToonReactor) {
        reactor.state.compactMap { $0.list }
            .bind(to: completeToonScrollView.completeToonView.selectToonCollectionView.rx.items(
                cellIdentifier: CreateToonCompleteToonCollectionViewCell.IDF,
                cellType: CreateToonCompleteToonCollectionViewCell.self)) { index, item, cell in
                    cell.setCell(item)
            }
                .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedUrls }
            .bind(to: completeToonScrollView.rx.selectedUrls)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: completeToonScrollView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.presentSaveToonVC }
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                
                let repo = ToonRepository()
                let useCase = ToonUseCase(repo: repo)
                let reactor = SaveToonReactor(model: model, useCase: useCase)
                let vc = SaveToonViewController(reactor: reactor)
                
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentProgress }
            .distinctUntilChanged()
            .skip(1)
            .bind(to: rx.currentProgress)
            .disposed(by: disposeBag)
    }
}
