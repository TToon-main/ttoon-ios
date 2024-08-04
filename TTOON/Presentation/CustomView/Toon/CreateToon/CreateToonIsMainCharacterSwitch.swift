//
//  CreateToonIsMainCharacterSwitch.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/28/24.
//

import UIKit

class CreateToonIsMainCharacterSwitch: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.font = .body16b
        view.textColor = .grey08
        view.text = "메인 캐릭터 여부"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.font = .body14m
        view.textColor = .grey06
        view.text = "만화를 생성할 때 기본으로\n선택되어있는 캐릭터에요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let switchView = {
        let view = TNSwitch()
        
        return view
    }()
    
    override func configures() {
        super.configures()
        backgroundColor = .grey01
        layer.cornerRadius = 8
    }
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(switchView)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {  
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {  
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        switchView.snp.makeConstraints {  
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }   
    }
}
