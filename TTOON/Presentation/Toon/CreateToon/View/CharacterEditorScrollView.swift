//
//  CharacterEditorScrollView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import UIKit

import RxCocoa
import RxSwift

class CharacterEditorScrollView: BaseView {
    // MARK: - UI Properties
    
    let characterEditorView = CharacterEditorView()
    
    private let scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    // MARK: - Configurations
    
    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(characterEditorView)
    }
    
    override func layouts() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        characterEditorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(width)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = characterEditorView.bounds.size
    }
}

// MARK: - Custom Observable

extension Reactive where Base: CharacterEditorScrollView {
    var nameTextDidChange: Observable<String> {
        return base.characterEditorView.nameInputView.rx.textDidChanged
    }
    
    var infoTextDidChange: Observable<String> {
        return base.characterEditorView.diaryInputTextView.rx.text
            .asObservable()
            .map({ text in
                let isPlaceholder = text == base.characterEditorView.placeholderText
                return isPlaceholder ? "" : text
            })
            .compactMap { $0 }
    }
    
    var isSwitchOn: Observable<Bool> {
        return base.characterEditorView.switchView.switchView.rx.isOn
            .asObservable()
    }
    
    var confirmButtonTap: Observable<AddCharacter?> {
        let base = base.characterEditorView
        
        return base.confirmButton.rx.tap
            .asObservable()
            .map { _ in
                guard let name = base.nameInputView.textFiled.text else {
                    return nil
                }
                
                guard let info = base.diaryInputTextView.text else {
                    return nil
                }
                
                let isMain = base.switchView.switchView.isOn
                
                return .init(isMain: isMain, name: name, info: info)
            }
    }
}

// MARK: - Custom Binder

extension Reactive where Base: CharacterEditorScrollView {
    var nameTextFiledCountLabel: Binder<String?> {
        return base.characterEditorView.nameInputView.rx.cntText
    }
    
    var infoTextFiledCountLabel: Binder<String?> {
        return base.characterEditorView.dairyLimitTextLabel.rx.cntText
    }
    
    var errorNameTextFiled: Binder<String?> {
        return base.characterEditorView.nameInputView.rx.errorMassage
    }
    
    var errorInfoTextFiled: Binder<String?> {
        return base.characterEditorView.dairyLimitTextLabel.rx.errorMassage
    }
    
    var isOn: Binder<Bool> {
        return base.characterEditorView.switchView.switchView.rx.isOn
    }
    
    var isEnabledConfirmButton: Binder<Bool> {
        return base.characterEditorView.confirmButton.rx.isEnabled
    }
}
