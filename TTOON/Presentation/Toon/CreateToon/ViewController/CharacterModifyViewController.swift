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
    private let viewLifeCycle = PublishSubject<CharacterModifyReactor.Action>()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLifeCycle.onNext(.viewLifeCycle(.viewWillAppear))
    }
    
    override func configures() {
        setNavigationItem()
    }
    
    // TODO: 임시
    func bindMockUp() {
        let characterData = CharacterPickerTableViewCellDataSource(name: "이름 1", isMainCharacter: true, characterDescription: "캐릭터에 대한 묘사 및 설명", isSelected: false, isModify: true)
        let mockUpData = Array(repeating: characterData, count: 20)
        let modifyButtonTap = PublishSubject<Void>()
        
        Observable.just(mockUpData)
            .bind(to: characterModifyView.tableView.rx.items(
                cellIdentifier: CharacterPickerTableViewCell.IDF,
                cellType: CharacterPickerTableViewCell.self)) { index, item, cell in
                    cell.setCell(item)
                    cell.modifyCharacterButton.rx.tap
                        .asObservable()
                        .subscribe(with: self) { owner, _ in
                            modifyButtonTap.onNext(())
                        }
                        .disposed(by: cell.disposeBag)
            }
                .disposed(by: disposeBag)
  
        
        modifyButtonTap
            .subscribe(with: self) { owner, _ in
                let reactor = CharacterEditReactor()
                let vc = CharacterEditViewController(reactor: reactor)
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
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
        characterModifyView.rx
            .deletedCharacterTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        characterModifyView.rx
            .addCharacterButtonTap
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CharacterModifyReactor) {
        reactor.state
            .map { $0.presentCharacterDeleteBS }
            .compactMap { $0 }
            .bind(onNext: presentCharacterDeleteBS)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentCharacterEditorVC }
            .compactMap { $0 }
            .bind(onNext: presentCharacterEditorVC)
            .disposed(by: disposeBag)
    }
}
