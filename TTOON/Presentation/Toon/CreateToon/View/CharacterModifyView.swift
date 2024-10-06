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
    
    let emptyListView = {
        let view = NoDataView("저장된 캐릭터가 없어요")
        view.isHidden = true
        
        return view
    }()
    
    let invalidView = {
        let view = NoDataView("캐릭터 조회에 실패했어요. 다시 시도해주세요")
        view.isHidden = true
        
        return view
    }()
    
    let idleView = UIView()
    
    override func addSubViews() {
        addSubview(tableView)
        addSubview(emptyListView)
        addSubview(invalidView)
        addSubview(idleView)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top).offset(-16)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        invalidView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        idleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
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
    
    var isHiddenEmptyListView: Binder<Bool> {
        return Binder(base) { view, isHidden in
            view.emptyListView.isHidden = isHidden
            view.invalidView.isHidden = true
            view.idleView.isHidden = true
        }
    }
    
    var isHiddenInvalidView: Binder<Bool> {
        return Binder(base) { view, isHidden in
            view.invalidView.isHidden = isHidden
            view.emptyListView.isHidden = true
            view.idleView.isHidden = true
        }
    }
    
    var isHiddenIdleView: Binder<Bool> {
        return Binder(base) { view, isHidden in
            view.idleView.isHidden = isHidden
            view.invalidView.isHidden = true
            view.emptyListView.isHidden = true
        }
    }
}
