//
//  CharacterDeleteBSViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterDeleteBSViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterDeleteBSView = CharacterDeleteBSView()
    private let viewLifeCycle = PublishSubject<CharacterDeleteBSReactor.Action>()
    
    init(reactor: CharacterDeleteBSReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLifeCycle.onNext(.viewLifeCycle(.viewWillAppear))
    }
    
    override func addSubViews() {
        view.addSubview(characterDeleteBSView)
    }
    
    override func layouts() {
        characterDeleteBSView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func bindMockUp() {
    }
}

extension CharacterDeleteBSViewController: View {
    func bind(reactor: CharacterDeleteBSReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterDeleteBSReactor) {
        viewLifeCycle
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterDeleteBSView.rx
            .backButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterDeleteBSView.rx
            .deleteButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterDeleteBSReactor) {
        reactor.state
            .map { $0.dismiss }
            .compactMap { $0 }
            .bind(onNext: dismiss)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.userName }
            .compactMap { $0 }
            .bind(to: characterDeleteBSView.rx.userName)
            .disposed(by: disposeBag)
    }
    
    private func dismiss() {
        self.dismiss(animated: true)
    }
}
