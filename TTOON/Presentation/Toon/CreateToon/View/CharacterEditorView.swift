//
//  CharacterEditorView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

class CharacterEditorView: BaseView {
    let titleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "새로운 등장인물에\n대해 설명해주세요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let nameInputTitleLabel = {
        let view = CreateToonMidSubTitleLabel()
        view.font = .body14m
        view.text = "등장인물 이름"
        
        return view
    }()
    
    lazy var titleContainer = {
        let view = UIStackView()
        
        return view
    }()
    
    let nameInputView = {
        let limitCnt: Int = 10
        let placeholderText = "홍길동"
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let diaryInputTitleLabel = {
        let view = CreateToonMidSubTitleLabel()
        view.font = .body14m
        view.text = "등장인물 특징"
        
        return view
    }()
    
    let diaryInputTextView = {
        let limitCnt: Int = 150
        let placeholderText = "등장인물에 대해 자세히 묘사해주시면 이미지의 정확도가 올라가요!\n(예: 검정색 단발머리, 20세 여성, 한국인 대학생, 청바지에 흰 티셔츠)"
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextLabel = {
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey05
        view.textAlignment = .right
        view.text = "0/150"
        view.numberOfLines = 0
        
        return view
    }()
    
    let switchView = CreateToonIsMainCharacterSwitch()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        
        return view
    }()
    
    let container = {
        let view = UIView()
        
        return view
    }()
    
    private let scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flex.define { 
            $0.addItem(scrollView)
            
            scrollView.flex.define { 
                $0.addItem(container).minHeight(height)
                
                container.flex.define {
                    if !titleLabel.isHidden {
                        $0.addItem(titleLabel).marginTop(36)
                    }
                    
                    $0.addItem(nameInputTitleLabel).marginTop(36)
                    $0.addItem(nameInputView).marginTop(8).height(52)
                    $0.addItem(diaryInputTitleLabel).marginTop(36)
                    $0.addItem(diaryInputTextView).marginTop(8).height(172)
                    $0.addItem(dairyLimitTextLabel)
                    $0.addItem(switchView).marginTop(36).height(98)
                    $0.addItem().minHeight(19).grow(1) // 스페이서 역할
                    $0.addItem(confirmButton).marginBottom(44).height(52)
                    $0.paddingLeft(16).paddingRight(16)
                }
            }
        }
        
        flex.layout()
        
        scrollView.pin.all()
        container.pin.all()
        scrollView.contentSize = container.bounds.size
    }
    
    func setUpView(editType: CharacterEditType) {
        titleLabel.isHidden = editType.isHiddenTitleLabel
    }
}
