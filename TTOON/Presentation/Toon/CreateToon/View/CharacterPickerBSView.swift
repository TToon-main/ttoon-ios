//
//  CharacterPickerBSView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import UIKit

import RxCocoa
import RxSwift

class CharacterPickerBSView: BaseView {
    let titleLabel = {
        let view = CreateToonMidTitleLabel()
        view.text = "등장인물을 모두 선택해주세요"
        
        return view
    }()
    
    let tableView = {
        let view = CharacterPickerTableView()
        
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
    
    let modifyCharacterButton = {
        let view = UIButton()
        view.setTitle("인물 추가 · 수정하기", for: .normal)
        view.setTitleColor(.grey06, for: .normal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .grey06
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        
        return view
    }()
    
    override func configures() {
        super.configures()
        layer.cornerRadius = 24
    }
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(emptyListView)
        addSubview(invalidView)
        addSubview(modifyCharacterButton)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(modifyCharacterButton.snp.top).offset(-24)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        invalidView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        modifyCharacterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top).offset(-32)
            $0.height.equalTo(24)
            $0.width.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}

// MARK: - Custom Binder
extension Reactive where Base: CharacterPickerBSView {
    var isHiddenEmptyListView: Binder<Bool> {
        return Binder(base) { view, isHidden in
            view.emptyListView.isHidden = isHidden
        }
    }
    
    var isHiddenInvalidView: Binder<Bool> {
        return Binder(base) { view, isHidden in
            view.invalidView.isHidden = isHidden
        }
    }
}
 
