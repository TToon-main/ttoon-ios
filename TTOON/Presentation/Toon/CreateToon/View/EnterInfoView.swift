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
    
    override func layouts() {
        flex.define { 
            $0.addItem(enterInfoTitleLabel).marginTop(36).marginHorizontal(16)
            $0.addItem(selectCharactersView).marginTop(48).marginHorizontal(16).height(94)
            $0.addItem(divider01).marginTop(28).alignSelf(.center)
            $0.addItem(enterDiaryTextView).marginTop(32).marginHorizontal(16).height(371)
            $0.addItem(confirmButton).marginTop(47).marginHorizontal(16).height(52).marginBottom(36)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
    }
}
