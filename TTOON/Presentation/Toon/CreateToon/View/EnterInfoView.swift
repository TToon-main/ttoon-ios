//
//  EnterInfoView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import FlexLayout
import PinLayout

class EnterInfoView: BaseView {
    let enterInfoTitleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "혜원님의 하루에 대해\n자세히 들려주세요"
        
        return view
    }()
    
    let selectCharactersView = CreateToonSelectCharactersView()
    
    let divider01 = CreateToonDivider()
    
    let enterDiaryTextView = CreateToonDiaryView()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
        
        return view
    }()
    
    override func addSubViews() {
        [enterInfoTitleLabel, selectCharactersView, divider01, enterDiaryTextView, confirmButton].forEach { v in
            addSubview(v)
        }
    }
    
    override func layouts() {
        enterInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(68)
        }
        
        selectCharactersView.snp.makeConstraints { make in
            make.top.equalTo(enterInfoTitleLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(94)
        }
        
        divider01.snp.makeConstraints { make in
            make.top.equalTo(selectCharactersView.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
        }
        
        enterDiaryTextView.snp.makeConstraints { make in
            make.top.equalTo(divider01.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(enterDiaryTextView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(36)
        }
    }
}
