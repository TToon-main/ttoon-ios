//
//  DeleteAccountView.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import FlexLayout
import PinLayout
import UIKit

class DeleteAccountView: BaseView {
    // root view가 될 컨테이너
    fileprivate let rootFlexContainer = UIView()
    
    // MARK: UI Components
    let mainTitleLabel = {
        let view = UILabel()
        view.text = "조혜원님이 떠나신다니\n너무 아쉬워요"
        view.font = .title24b
        view.numberOfLines = 2
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.text = "탈퇴 사유를 공유해주시면 반영하여\n더 좋은 서비스를 제공하기 위해 노력할게요."
        view.font = .body16m
        view.textColor = .grey06
        view.numberOfLines = 2
        return view
    }()
    
    let nameTitleLabel = SettingTitleLabel("이름")
    let nameInputView = SettingNameInputView("조혜원")
    
    let reasonTitleLabel = SettingTitleLabel("탈퇴 이유")
    let reasonPickerView = SettingPickerView("탈퇴하시는 이유를 알려주세요")
    let reasonTextView = SettingTextView(placeholderText: "탈퇴하시는 이유를 알려주세요", limitCnt: 100)
    let reasonErrorSubtitleLabel = SettingSubtitleLabel("100자 내로 입력해주세요")
    let reasonCountLabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = .grey05
        view.font = .body14r
        view.text = "0/100"
        return view
    }()
    
    let completeButton = {
        let view = UIButton()
        view.backgroundColor = .black
        return view
    }()
    

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(rootFlexContainer)
    }
    
    override func layouts() {
        super.layouts()
        
        rootFlexContainer.flex.width(100%)
            .direction(.column)
            .justifyContent(.spaceBetween)
            .paddingHorizontal(16)
            .define { flex in
                flex.addItem().direction(.column).define { flex in
                    flex.addItem(mainTitleLabel).marginTop(35).height(68)
                    flex.addItem(subTitleLabel).marginTop(16).height(48)
                    
                    flex.addItem(nameTitleLabel).marginTop(40)
                    flex.addItem(nameInputView).marginTop(8)
                        .height(52)
                    
                    flex.addItem(reasonTitleLabel).marginTop(36)
                    flex.addItem(reasonPickerView).marginTop(8)
                        .height(52)
                    flex.addItem(reasonTextView).marginTop(8).height(151)
                    
                    
                    flex.addItem().direction(.rowReverse).justifyContent(.spaceBetween).marginTop(8).define { flex in
                        flex.addItem(reasonCountLabel).grow(1)
                        flex.addItem(reasonErrorSubtitleLabel)
                    }
                }
                
                flex.addItem(completeButton)
                    .height(56)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout(mode: .fitContainer)
    }
}
