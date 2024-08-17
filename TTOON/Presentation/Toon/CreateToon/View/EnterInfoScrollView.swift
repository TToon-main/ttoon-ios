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
        flex.define { 
            $0.addItem(scrollView)
            
            scrollView.flex.define { 
                $0.addItem(enterInfoView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all()
        enterInfoView.pin.all()
        scrollView.contentSize = enterInfoView.frame.size
    }   
}

extension Reactive where Base: EnterInfoScrollView {
    var textFieldDidChange: Observable<EnterInfoReactor.Action> {
        return base.enterInfoView.enterDiaryTextView.diaryInputTextView.rx.text
            .compactMap { $0 }
            .distinctUntilChanged()
            .map { EnterInfoReactor.Action.textFieldDidChange($0)}
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
}
