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
    private let completeToonView = CompleteToonView()
    
    init(reactor: CompleteToonReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layouts() {
        super.layouts()
        view.addSubview(completeToonView)
        
        completeToonView.snp.makeConstraints { 
            $0.top.equalTo(progressBar.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configures() {
        super.configures()
        setNavigationItem(title: "네컷만화 완성하기")
        view.backgroundColor = .white
    }
}

extension CompleteToonViewController: View {
    func bind(reactor: CompleteToonReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CompleteToonReactor) {
    }
    
    private func bindState(reactor: CompleteToonReactor) {
    }
}
