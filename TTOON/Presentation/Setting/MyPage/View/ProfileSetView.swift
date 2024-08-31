//
//  ProfileSetView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

import RxCocoa
import RxSwift

class ProfileSetView: BaseView {
    let profileImageView = {
        let view = UIImageView()
        view.image = TNImage.userIcon
        
        return view
    }()
    
    let changeImageButton = {
        let view = UIButton()
        view.setImage(TNImage.addProfileIcon, for: .normal)
        
        return view
    }()
    
    let textFiledTitleLabel = {
        let view = UILabel()
        view.text = "닉네임"
        view.textColor = .grey06
        view.font = .body14m
        
        return view
    }()
    
    let nickNameTextFiled = {
        let view = TNTextFiled()
        view.textFiled.placeholder = "닉네임 (최대 10자)"
        view.textFiled.clearButtonMode = .always
        
        return view
    }()
    
    let divider = {
        let view = UIView()
        view.backgroundColor = .grey01
        
        return view
    }()
    
    let userInfoTitleLabel = {
        let view = UILabel()
        view.text = "계정 정보"
        view.textColor = .grey06
        view.font = .body14m
        
        return view
    }()
    
    let emailStackView = {
        let view = ProfileSetStackView()
        view.titleLabel.text = "이메일"
        
        return view
    }()
    
    let saveButton = {
        let view = TNButton()
        view.isEnabled = false
        view.setTitle("저장", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        self.addSubview(profileImageView)
        self.addSubview(changeImageButton)
        self.addSubview(textFiledTitleLabel)
        self.addSubview(nickNameTextFiled)
        self.addSubview(divider)
        self.addSubview(userInfoTitleLabel)
        self.addSubview(emailStackView)
        self.addSubview(saveButton)
    }
    
    override func layouts() {
        profileImageView.snp.makeConstraints { 
            $0.centerX.equalToSuperview()
            $0.size.equalTo(90)
            $0.top.equalTo(safeGuide).offset(55)
        }
        
        changeImageButton.snp.makeConstraints { 
            $0.bottom.equalTo(profileImageView) 
            $0.trailing.equalTo(profileImageView)
            $0.size.equalTo(24)
        }
        
        textFiledTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(profileImageView.snp.bottom).offset(24) 
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nickNameTextFiled.snp.makeConstraints { 
            $0.top.equalTo(textFiledTitleLabel.snp.bottom).offset(8) 
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints { 
            $0.height.equalTo(8)
            $0.top.equalTo(nickNameTextFiled.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
        }
        
        userInfoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        emailStackView.snp.makeConstraints { 
            $0.top.equalTo(userInfoTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { 
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeGuide).offset(-36)
        }
    }
}

extension Reactive where Base: ProfileSetView {
    var model: Binder<SetProfileResponseModel> {
        return Binder(base) { view, model  in            
            view.profileImageView.load(url: model.profileUrl)
            view.nickNameTextFiled.textFiled.text = model.nickName
            view.emailStackView.setUp(model.emailStackInfo)
        }
    }
    
    var copyButtonTap: Observable<String> {
        return base.emailStackView.copyButton.rx.tap
            .compactMap { _ in  return base.emailStackView.infoLabel.text }
    }
    
    var textFiledText: Observable<String> {
        return base.nickNameTextFiled.rx.textDidChange
    }
    
    var truncatedText: Binder<String> {
        return Binder(base) { view, text in
            view.nickNameTextFiled.textFiled.text = text
        }
    }
    
    var errorMessage: Binder<String?> {
        return base.nickNameTextFiled.rx.errorMassage
    }
} 
