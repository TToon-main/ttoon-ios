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
    // MARK: UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let mainTitleLabel = {
        let view = UILabel()
        view.text = "000님이 떠나신다니\n너무 아쉬워요"
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
    
    let nameTitleLabel = SettingTitleLabel("닉네임")
    let nameInputView = SettingNameInputView("000")
    
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
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
        return view
    }()
    

    override func addSubViews() {
        super.addSubViews()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [mainTitleLabel, subTitleLabel, nameTitleLabel, nameInputView, reasonTitleLabel, reasonPickerView, reasonTextView, reasonErrorSubtitleLabel, reasonCountLabel, completeButton].forEach {
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
        
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.height.equalTo(68)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nameInputView.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reasonTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameInputView.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reasonPickerView.snp.makeConstraints { make in
            make.top.equalTo(reasonTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonPickerView.snp.bottom).offset(8)
            make.height.equalTo(151)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reasonCountLabel.snp.makeConstraints { make in
            make.top.equalTo(reasonTextView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reasonErrorSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(reasonTextView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(reasonCountLabel.snp.bottom).offset(54)
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView)
        }
    }
}
