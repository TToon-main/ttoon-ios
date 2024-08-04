//
//  CharacterModifyView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import RxSwift
import UIKit

import RxCocoa

class CharacterModifyView: BaseView {
    let tableView = {
        let view = CharacterPickerTableView()
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("인물 추가하기", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(tableView)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeGuide)
            $0.horizontalEdges.equalTo(safeGuide).inset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}

extension Reactive where Base: CharacterModifyView {
    var deletedCharacterTap: Observable<CharacterModifyReactor.Action> {
        return base.tableView.rx.itemDeleted
            .flatMap { indexPath -> Observable<CharacterModifyReactor.Action> in
                guard let cell = base.tableView.cellForRow(at: indexPath) as? CharacterPickerTableViewCell else {
                    return .never()
                }
                
                let name = cell.titleLabel.text
                let action = CharacterModifyReactor.Action.deletedCharacterTap(name)
                
                return .just(action) 
            }
    }
    
    var addCharacterButtonTap: Observable<CharacterModifyReactor.Action> {
        return base.confirmButton.rx.tap
            .map { CharacterModifyReactor.Action.addCharacterButtonTap }
    }
}
