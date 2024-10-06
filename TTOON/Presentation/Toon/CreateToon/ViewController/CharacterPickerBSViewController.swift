//
//  CharacterPickerBSViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterPickerBSViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterPickerBSView = CharacterPickerBSView()
    
    init(reactor: CharacterPickerBSReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        view.addSubview(characterPickerBSView)
    }
    
    override func layouts() {
        characterPickerBSView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func dismiss(_ flag: Bool) {
        if flag {
            self.dismiss(animated: true)
        }
    }
}

extension CharacterPickerBSViewController: View {
    func bind(reactor: CharacterPickerBSReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterPickerBSReactor) {
        rx.viewWillAppear
            .map { _ in CharacterPickerBSReactor.Action.refreshCharacterList}
			.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterPickerBSView.rx.confirmButtonTap
            .map{ CharacterPickerBSReactor.Action.confirmButtonTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterPickerBSView.rx.modifyCharacterButtonTap
            .map{ CharacterPickerBSReactor.Action.modifyCharacterButtonTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterPickerBSView.rx.modelSelected
            .map{ CharacterPickerBSReactor.Action.modelSelected(model: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterPickerBSReactor) {
        reactor.state.compactMap { $0.characterList }
            .bind(to: characterPickerBSView.tableView.rx.items(
                cellIdentifier: CharacterPickerTableViewCell.IDF,
                cellType: CharacterPickerTableViewCell.self))
        { index, item, cell in
            cell.setCell(item)
            }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenEmptyView }
            .bind(to: characterPickerBSView.rx.isHiddenEmptyListView)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenInvalidView }
            .bind(to: characterPickerBSView.rx.isHiddenInvalidView)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEnabledConfirmButton }
            .bind(to: characterPickerBSView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isDismiss }
            .bind(onNext: dismiss)
            .disposed(by: disposeBag)
    }
}
