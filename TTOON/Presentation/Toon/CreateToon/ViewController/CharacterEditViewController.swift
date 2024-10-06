//
//  CharacterEditViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/28/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterEditViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterEditorScrollView = CharacterEditorScrollView()
    
    init(reactor: CharacterEditReactor) {
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
        characterEditorScrollView.characterEditorView.setUpView(editType: .edit)
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 수정"
        self.navigationItem.backButtonTitle = ""
        
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAction))
        deleteButton.tintColor = .errorRed
        deleteButton.setTitleTextAttributes([.font: UIFont.body16m], for: .normal)

        self.navigationItem.rightBarButtonItem = deleteButton
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @objc func deleteAction() {
        self.reactor?.action.onNext(.deletedButtonTap)
    }
    
    private func pop(_ flag: Bool) {
        if flag {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func presentFailToast(_ flag: Bool) {
        if flag {
            // TODO: - 토스트 메세지
        }
    }
}

extension CharacterEditViewController: View {
    func bind(reactor: CharacterEditReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterEditReactor) {
        reactor.action.onNext(.setInitialData)
        
        characterEditorScrollView.rx.nameTextDidChange
            .map { CharacterEditReactor.Action.nameText(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterEditorScrollView.rx.infoTextDidChange
            .map { CharacterEditReactor.Action.infoText(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterEditorScrollView.rx.isSwitchOn
            .map { CharacterEditReactor.Action.isMainCharacter(isMain: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterEditorScrollView.rx.confirmButtonTap
            .compactMap{ $0 }
            .map { CharacterEditReactor.Action.confirmButtonTap(model: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterEditReactor) {
        reactor.state.map { $0.nameTextFiledCountLabel }
            .distinctUntilChanged()
            .bind(to: characterEditorScrollView.rx.nameTextFiledCountLabel)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.infoTextFiledCountLabel }
            .distinctUntilChanged()
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
        
        reactor.state.compactMap { $0.nameText }
            .bind(to: characterEditorScrollView.rx.nameText)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.infoText }
            .bind(to: characterEditorScrollView.rx.infoText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pop }
            .bind(onNext: pop)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.presentFailToast }
            .bind(onNext: presentFailToast)
            .disposed(by: disposeBag)
    }
}
