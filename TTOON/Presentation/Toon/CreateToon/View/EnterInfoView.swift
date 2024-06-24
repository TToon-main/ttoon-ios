//
//  EnterInfoView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

class EnterInfoView: BaseView {
    let enterInfoTitleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "혜원님의 하루에 대해\n자세히 들려주세요"
        
        return view
    }()
    
    let selectCharactersView = {
        let view = CreateToonSelectCharactersView()
        
        return view
    }()
    
    let divider01 = {
        let view = CreateToonDivider()
        
        return view
    }()
    
    let enterDiaryTextView = {
        let view = CreateToonDiaryView()
    
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(enterInfoTitleLabel)
        addSubview(selectCharactersView)
        addSubview(divider01)
        addSubview(enterDiaryTextView)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        enterInfoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        selectCharactersView.snp.makeConstraints {
            $0.top.equalTo(enterInfoTitleLabel.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(94)
        }
        
        divider01.snp.makeConstraints {
            $0.top.equalTo(selectCharactersView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        enterDiaryTextView.snp.makeConstraints {
            $0.top.equalTo(divider01.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(371)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(enterDiaryTextView.snp.bottom).offset(47)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-36)
        }
    }
}
