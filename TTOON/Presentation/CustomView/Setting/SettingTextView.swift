//
//  SettingTextView.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import RxSwift
import UIKit


class SettingTextView: UITextView {
    private var placeholderText: String = ""
    private var limitCnt: Int = 1000
    private var disposeBag = DisposeBag()
    
    convenience init(placeholderText: String, limitCnt: Int) {
        self.init()
        
        self.placeholderText = placeholderText
        self.limitCnt = limitCnt
        
        self.setUp()
        self.bind()
    }
    
    
    private func setUp() {
        // font
        self.font = .body16m
        
        // placeholder
        self.text = placeholderText
        self.textColor = .grey05
        
        // background
        self.backgroundColor = .grey01
        
        // border
        self.clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
        // padding
        self.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private func bind() {
        // border color
        self.rx.text    // placeholder일 때 고려 (200일땐 상관 없음)
            .subscribe(with: self) { owner, value in
                if let length = value?.count {
                    owner.layer.borderColor = (length <= owner.limitCnt) ? UIColor.clear.cgColor : UIColor(hexString: "#FF6666")?.cgColor
                }
            }
            .disposed(by: disposeBag)
        
        
        // placeholder
        self.rx.didBeginEditing
            .subscribe(with: self) { owner, text in
                // textColor 판단 후 placeholder이면 text 날려준다
                if owner.textColor == UIColor.grey05 {
                    owner.text = nil
                    owner.textColor = UIColor.black
                }
            }
            .disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .subscribe(with: self) { owner, _ in
                // text가 비어있으면 placeholder를 띄워준다
                if owner.text.isEmpty {
                    owner.text = owner.placeholderText
                    owner.textColor = .grey05
                }
            }
            .disposed(by: disposeBag)
    }
}
