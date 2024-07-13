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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
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
        
        characterModifyView.confirmButton.rx.tap
            .subscribe(with: self) { owner, _ in 
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        characterModifyView.tableView.rx.itemDeleted
            .subscribe(with: self) { owner, _ in
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 목록"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension CharacterModifyViewController: View {
    func bind(reactor: CharacterModifyReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterModifyReactor) {
    }
    
    func bindState(reactor: CharacterModifyReactor) {
    }
}
