//
//  CharacterEditorView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift

class CharacterEditorView: BaseView {
    let placeholderText = "등장인물에 대해 자세히 묘사해주시면 이미지의 정확도가 올라가요!\n(예: 검정색 단발머리, 20세 여성, 한국인 대학생, 청바지에 흰 티셔츠)"
    
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
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(nameInputTitleLabel)
        view.axis = .vertical
        view.spacing = 36
        
        return view
    }()
    
    let nameInputView = {
        let view = TNTextFiled()
        view.textFiled.placeholder = "홍길동"
        view.statusLabel.textCntLabel.text = "0"
        view.statusLabel.textLimitLabel.text = "/10"
        
        return view
    }()
    
    let diaryInputTitleLabel = {
        let view = CreateToonMidSubTitleLabel()
        view.font = .body14m
        view.text = "등장인물 특징"
        
        return view
    }()
    
    lazy var diaryInputTextView = {
        let limitCnt: Int = 150
        let placeholderText = placeholderText
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextLabel = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/150"
        
        return view
    }()
    
    let switchView = CreateToonIsMainCharacterSwitch()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
        
        return view
    }()
    
    override func addSubViews() {
        [titleContainer,
         nameInputView,
         diaryInputTitleLabel,
         diaryInputTextView,
         dairyLimitTextLabel,
         switchView,
         confirmButton]
            .forEach { v in
                addSubview(v)
            }
    }
    
    override func layouts() {
        titleContainer.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nameInputTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        nameInputView.snp.makeConstraints {
            $0.top.equalTo(titleContainer.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        diaryInputTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nameInputView.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        diaryInputTextView.snp.makeConstraints {
            $0.top.equalTo(diaryInputTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(172)
        }
        
        dairyLimitTextLabel.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        switchView.snp.makeConstraints {
            $0.top.equalTo(dairyLimitTextLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(98)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(switchView.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-44)
        }
    }
    
    func setUpView(editType: CharacterEditType) {
        titleLabel.isHidden = editType.isHiddenTitleLabel
    }
}
