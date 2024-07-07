//
//  ContactUsView.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import FlexLayout
import PinLayout
import UIKit

class ContactUsView: BaseView {
    // root view가 될 컨테이너
    fileprivate let rootFlexContainer = UIView()
    
    // MARK: UI Components
    let emailTitleLabel = SettingTitleLabel("이메일")
    let categoryTitleLabel = SettingTitleLabel("문의 유형")
    let contentTitleLabel = SettingTitleLabel("문의내용")
    
    let emailTextField = SettingTextField("example@email.com")
    let categoryPickerView = SettingPickerView("카테고리를 선택해주세요")
    let contentTextView = SettingTextView(placeholderText: "어떤 내용이 궁금하신가요?", limitCnt: 200)
    
    let emailSubtitleLabel = SettingSubtitleLabel("문의에 대한 답변을 이메일로 보내드려요")
    let contentErrorSubtitleLabel = SettingSubtitleLabel("200자 내로 입력해주세요")
    let contentCountLabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = .grey05
        view.font = .body14r
        view.text = "0/200"
        return view
    }()
    
//    let completeButton = {
//        let view = UIButton()
//        view.backgroundColor = .black
//        return view
//    }()
    
    let completeButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
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
                    flex.addItem(emailTitleLabel).marginTop(50)
                    flex.addItem(emailTextField).marginTop(8).height(52)
                    flex.addItem(emailSubtitleLabel).marginTop(8)
                    
                    flex.addItem(categoryTitleLabel).marginTop(36)
                    flex.addItem(categoryPickerView).marginTop(8)
                        .height(52)
                    
                    flex.addItem(contentTitleLabel).marginTop(36)
                    flex.addItem(contentTextView).marginTop(8)
                        .height(260)
                    
                    
                    flex.addItem().direction(.rowReverse).justifyContent(.spaceBetween).marginTop(8).define { flex in
                        flex.addItem(contentCountLabel).grow(1)
                        flex.addItem(contentErrorSubtitleLabel)
                    }
                }
                
                flex.addItem(completeButton)
                    .height(56)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 부모뷰에 대한 컨테이너 레이아웃 설정 (safeArea에 맞춤 - x)
        rootFlexContainer.pin.all(pin.safeArea)
        // 컨테이너 사이즈 설정 (내부 아이템 높이에 맞춤 - x)
        rootFlexContainer.flex.layout(mode: .fitContainer)
    }
}
