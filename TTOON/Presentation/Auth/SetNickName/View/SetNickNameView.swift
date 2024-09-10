//
//  SetNickNameView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import UIKit

import RxCocoa
import RxSwift

class SetNickNameView: BaseView {
    let titleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "닉네임을 입력해주세요"
        
        return view
    }()
    
    let textFiledTitleLabel = {
        let view = UILabel()
        view.text = "닉네임"
        view.textColor = .grey06
        view.font = .body14m
        
        return view
    }()
    
    let textField = {
        let view = TNTextFiled()
        view.textFiled.placeholder = "닉네임 (최대 10자)"
        view.textFiled.clearButtonMode = .always
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("저장", for: .normal)
        view.isEnabled = false
        
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(textFiledTitleLabel)
        addSubview(textField)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(39)
            $0.leading.equalToSuperview().offset(16)
        }
        
        textFiledTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        textField.snp.makeConstraints { 
            $0.top.equalTo(textFiledTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints { 
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeGuide).offset(-36)
        }
    }
}


// MARK: - Custom Observable
extension Reactive where Base: SetNickNameView {
    var textDidChanged: Observable<String> {
        return base.textField.rx.textDidChanged
    }
    
    var confirmButtonTap: Observable<String> {
        return base.confirmButton.rx.tap
            .compactMap { _ in return base.textField.textFiled.text }
    }
}

// MARK: - Custom Observer

extension Reactive where Base: SetNickNameView {
    var isFocusTextField: Binder<Bool> {
        return Binder(base) { view, isFocus in
            if isFocus {
                view.textField.textFiled.becomeFirstResponder()     
            }
        }
    }
    
    var text: Binder<String?> {
        return base.textField.rx.text
    }
    
    var isEnabledConfirmButton: Binder<Bool> {
        return base.confirmButton.rx.isEnabled
    }
    
    var isValidText: Binder<TextFieldStatus> {
        return Binder(base) { view, state in
            switch state {
            case .valid:
                print("요청 성공")
                
            case .duplication:
                print("중복된 요청")
                
            case .unknown:
                print("알 수 없는 에러 요청")
            }
        }
    }
}
