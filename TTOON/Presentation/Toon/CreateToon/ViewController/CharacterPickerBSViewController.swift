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

protocol PresentModifyCharacterVCDelegate: AnyObject {
    func presentModifyCharacterViewController()
}

class CharacterPickerBSViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterPickerBSView = CharacterPickerBSView()
    weak var delegate: PresentModifyCharacterVCDelegate?
    
    init(reactor: CharacterPickerBSReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterPickerBSView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    func bindMockUp() {
        let mockUpData = [
            CharacterPickerTableViewCellDataSource(name: "이름 1", isMainCharacter: true, characterDescription: "캐릭터에 대한 묘사 및 설명", isSelected: false, isModify: false),
            CharacterPickerTableViewCellDataSource(name: "이름 1", isMainCharacter: true, characterDescription: "캐릭터에 대한 묘사 및 설명", isSelected: true, isModify: false),
            CharacterPickerTableViewCellDataSource(name: "이름 1", isMainCharacter: true, characterDescription: "캐릭터에 대한 묘사 및 설명", isSelected: true, isModify: false)]
        
        Observable.just(mockUpData)
            .bind(to: characterPickerBSView.tableView.rx.items(
                cellIdentifier: CharacterPickerTableViewCell.IDF,
                cellType: CharacterPickerTableViewCell.self)) { index, item, cell in
                    cell.setCell(item)
            }
                .disposed(by: disposeBag)
        
        characterPickerBSView.modifyCharacterButton.rx.tap
            .subscribe(with: self) { owner, _ in 
                owner.dismiss(animated: true)
                owner.delegate?.presentModifyCharacterViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension CharacterPickerBSViewController: View {
    func bind(reactor: CharacterPickerBSReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterPickerBSReactor) {
    }
    
    func bindState(reactor: CharacterPickerBSReactor) {
    }
}
