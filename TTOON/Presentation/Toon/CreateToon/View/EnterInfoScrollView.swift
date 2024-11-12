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
    var dairyTextView1DidChange: Observable<EnterInfoReactor.Action> {
        let diaryInputTextView = base.enterInfoView.enterDiaryTextView.diaryInputTextView1
        
        return diaryInputTextView.rx.text
            .compactMap { $0 }
            .filter { $0 != diaryInputTextView.placeholderText }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.dairyTextView1DidChange($0)}
    }
    
    var dairyTextView2DidChange: Observable<EnterInfoReactor.Action> {
        let diaryInputTextView = base.enterInfoView.enterDiaryTextView.diaryInputTextView2
        
        return diaryInputTextView.rx.text
            .compactMap { $0 }
            .filter { $0 != diaryInputTextView.placeholderText }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.dairyTextView2DidChange($0)}
    }
    
    var dairyTextView3DidChange: Observable<EnterInfoReactor.Action> {
        let diaryInputTextView = base.enterInfoView.enterDiaryTextView.diaryInputTextView3
        
        return diaryInputTextView.rx.text
            .compactMap { $0 }
            .filter { $0 != diaryInputTextView.placeholderText }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.dairyTextView3DidChange($0)}
    }
    
    var dairyTextView4DidChange: Observable<EnterInfoReactor.Action> {
        let diaryInputTextView = base.enterInfoView.enterDiaryTextView.diaryInputTextView4
        
        return diaryInputTextView.rx.text
            .compactMap { $0 }
            .filter { $0 != diaryInputTextView.placeholderText }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.dairyTextView4DidChange($0)}
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
    
    var dairyTextView1Error: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView1.rx.errorMassage
    }
    
    var dairyTextView1TextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView1.rx.cntText
    }
    
    var dairyTextView2Error: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView2.rx.errorMassage
    }
    
    var dairyTextView2TextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView2.rx.cntText
    }
    
    var dairyTextView3Error: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView3.rx.errorMassage
    }
    
    var dairyTextView3TextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView3.rx.cntText
    }
    
    var dairyTextView4Error: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView4.rx.errorMassage
    }
    
    var dairyTextView4TextCount: Binder<String?> {
        return base.enterInfoView.enterDiaryTextView.dairyLimitTextView4.rx.cntText
    }
    
    var isEnabledConfirmButton: Binder<Bool> {
        return base.enterInfoView.confirmButton.rx.isEnabled
    }
}
