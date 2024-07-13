//
//  CharacterModifyView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

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
