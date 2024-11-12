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
    
    override func configures() {
        super.configures()
        setNavigationItem(title: "네컷만화 완성하기")
        view.backgroundColor = .white
        completeToonScrollView.completeToonView.setUpView(isCompleted: false)
    }
    
    override func layouts() {
        super.layouts()
        view.addSubview(completeToonScrollView)
        
        completeToonScrollView.snp.makeConstraints { 
            $0.top.equalTo(progressContainer.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
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
    }
}
