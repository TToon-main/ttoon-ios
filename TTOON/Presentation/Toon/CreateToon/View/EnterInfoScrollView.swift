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
        
        // 스크롤 뷰의 핵심! -> contentsize를 명시하지 않으면, 스크롤이 되지 않는다.
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
}

extension Reactive where Base: EnterInfoScrollView {
    var validTextFieldText: Binder<String?> {
        return Binder(base) { view, text in
            view.enterInfoView.enterDiaryTextView.diaryInputTextView.text = text
        }
    }
}
