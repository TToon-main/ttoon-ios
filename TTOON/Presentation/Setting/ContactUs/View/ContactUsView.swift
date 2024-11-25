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
    // MARK: UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    
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
    
    let completeButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
        return view
    }()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [emailTitleLabel, categoryTitleLabel, contentTitleLabel, emailTextField,
         categoryPickerView, contentTextView, emailSubtitleLabel, contentErrorSubtitleLabel,
         contentCountLabel, completeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            make.width.equalTo(scrollView)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emailSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailSubtitleLabel.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        categoryPickerView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryPickerView.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(260)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentErrorSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(contentCountLabel.snp.bottom).offset(16)
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView)
        }
    }
}
