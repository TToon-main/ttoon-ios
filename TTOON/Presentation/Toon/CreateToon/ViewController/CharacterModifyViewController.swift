//
//  CharacterModifyViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterModifyViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterModifyView = CharacterModifyView()
    
    init(reactor: CharacterModifyReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterModifyView
    }
    
    override func configures() {
        setNavigationItem()
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 목록"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func presentCharacterDeleteBS(name: String?) {
        let reactor = CharacterDeleteBSReactor(userName: name)
        let viewControllerToPresent = CharacterDeleteBSViewController(reactor: reactor)
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.custom { context in return 392 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func  presentCharacterEditorVC() {
        let repo = ToonRepository()
        let useCase = ToonUseCase(repo: repo)
        let reactor = CharacterAddReactor(useCase: useCase)
        let vc = CharacterAddViewController(reactor: reactor)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CharacterModifyViewController: View {
    func bind(reactor: CharacterModifyReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterModifyReactor) {
        reactor.action.onNext(.viewDidLoad)
        
        characterModifyView.rx.deletedCharacterTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterModifyView.rx.addCharacterButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterModifyReactor) {
        reactor.state.compactMap { $0.characterList }
            .bind(to: characterModifyView.tableView.rx.items(
                cellIdentifier: CharacterPickerTableViewCell.IDF,
                cellType: CharacterPickerTableViewCell.self))
        { index, item, cell in
            cell.setCell(item, cellType: .modify)
            }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.presentCharacterDeleteBS }
            .compactMap { $0 }
            .bind(onNext: presentCharacterDeleteBS)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.presentCharacterEditorVC }
            .compactMap { $0 }
            .bind(onNext: presentCharacterEditorVC)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenEmptyView }
            .bind(to: characterModifyView.rx.isHiddenEmptyListView)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenIdleView }
            .bind(to: characterModifyView.rx.isHiddenIdleView)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHiddenInvalidView }
            .bind(to: characterModifyView.rx.isHiddenInvalidView)
            .disposed(by: disposeBag)
    }
}
