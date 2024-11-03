//
//  CharacterEditorViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterAddViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterEditorScrollView = CharacterEditorScrollView()
    
    init(reactor: CharacterAddReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterEditorScrollView
    }
    
    override func configures() {
        setNavigationItem()
        characterEditorScrollView.characterEditorView.setUpView(editType: .add)
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 추가"
        self.navigationItem.backButtonTitle = ""
    }
}

extension CharacterAddViewController: View {
    func bind(reactor: CharacterAddReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterAddReactor) {
        characterEditorScrollView.rx.nameTextDidChange
            .map { CharacterAddReactor.Action.nameText(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterEditorScrollView.rx.infoTextDidChange
            .map { CharacterAddReactor.Action.infoText(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterEditorScrollView.rx.isSwitchOn
            .map { CharacterAddReactor.Action.isMainCharacter(isMain: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterAddReactor) {
        reactor.state.map { $0.nameTextFiledCountLabel }
            .bind(to: characterEditorScrollView.rx.nameTextFiledCountLabel)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.infoTextFiledCountLabel }
            .bind(to: characterEditorScrollView.rx.infoTextFiledCountLabel)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorNameTextFiled }
            .distinctUntilChanged()
            .bind(to: characterEditorScrollView.rx.errorNameTextFiled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorInfoTextFiled }
            .distinctUntilChanged()
            .bind(to: characterEditorScrollView.rx.errorInfoTextFiled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isOn }
            .bind(to: characterEditorScrollView.rx.isOn)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: characterEditorScrollView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
    }
}
