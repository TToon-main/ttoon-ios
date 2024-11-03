//
//  EnterInfoScrollView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/21/24.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

class EnterInfoScrollView: BaseView {
    let enterInfoView = EnterInfoView()
    
    private let scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    override func layouts() {
        scrollView.addSubview(enterInfoView)
        addSubview(scrollView)
        
        enterInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(width)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = enterInfoView.bounds.size
    }
}

extension Reactive where Base: EnterInfoScrollView {
    var dairyTextViewDidChange: Observable<EnterInfoReactor.Action> {
        let diaryInputTextView = base.enterInfoView.enterDiaryTextView.diaryInputTextView
        
        return diaryInputTextView.rx.text
            .compactMap { $0 }
            .filter { $0 != diaryInputTextView.placeholderText }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.dairyTextViewDidChange($0)}
    }
    
    var titleTextFieldTextDidChange: Observable<String> {
        return base.enterInfoView.enterDiaryTextView.diaryTitleTextField.rx.textDidChanged
    }
    
    var confirmButtonTap: Observable<EnterInfoReactor.Action> {
        return base.enterInfoView.confirmButton.rx.tap
            .map { EnterInfoReactor.Action.confirmButtonTap }
    }
    
    var selectCharactersButtonTap: Observable<EnterInfoReactor.Action> {
        return base.enterInfoView.selectCharactersView.selectCharactersButton.rx.tap
            .map { EnterInfoReactor.Action.selectCharactersButtonTap }
    }
}

extension Reactive where Base: EnterInfoScrollView {
    var validTextFieldText: Binder<String?> {
        return Binder(base) { view, text in
            view.enterInfoView.enterDiaryTextView.diaryInputTextView.text = text
        }
    }
    
    var characterButtonText: Binder<String?> {
        return Binder(base) { view, text in
            if let text = text {
                base.enterInfoView.selectCharactersView
                    .selectCharactersButton
                    .setSelectedCharactersText(text)
            } else {
                base.enterInfoView.selectCharactersView
                    .selectCharactersButton
                    .setDefaultText()
            }
        }
    }
    
    var titleTextFiledError: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.diaryTitleTextField.rx.errorMassage
    }
    
    var titleTextFieldTextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.diaryTitleTextField.rx.cntText
    }
    
    var dairyTextViewError: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView.rx.errorMassage
    }
    
    var dairyTextViewTextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView.rx.cntText
    }
    
    var isEnabledConfirmButton: Binder<Bool> {
        return base.enterInfoView.confirmButton.rx.isEnabled
    }
}
