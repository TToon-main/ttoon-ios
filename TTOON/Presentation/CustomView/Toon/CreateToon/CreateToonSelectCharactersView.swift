//
//  CreateToonSelectCharactersView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

class CreateToonSelectCharactersView: BaseView {
    let midTitleLabel = {
        let view = CreateToonMidTitleLabel()
        view.text = "저장된 등장인물 선택"
        view.numberOfLines = 0
        
        return view
    }()
    
    let selectCharactersButton = {
        let view = CreateToonSelectCharactersButton()
        
        return view
    }()
    
    override func configures() {
        backgroundColor = .clear
    }
    
    override func addSubViews() {
        addSubview(midTitleLabel)
        addSubview(selectCharactersButton)
    }
    
    override func layouts() {
        midTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        selectCharactersButton.snp.makeConstraints {
            $0.top.equalTo(midTitleLabel.snp.bottom).offset(16)
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}
