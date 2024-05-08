//
//  TNButton.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/8/24.
//

import UIKit

import RxCocoa
import RxSwift

class TNButton: UIButton {
    private let disposeBag = DisposeBag()
    
    override var isEnabled: Bool {
        didSet {
            setBackgroundColor(isEnabled)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setBind()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
    
    private func setUI() {
        backgroundColor = .tnOrange
        titleLabel?.font = .body18m
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 12
    }
    
    private func setBind() {
        rx.isHighlighted
            .subscribe(with: self) { owner, flag in 
                owner.setBackgroundColor(flag)
            }
            .disposed(by: disposeBag)
        
        rx.isSelected
            .subscribe(with: self) { owner, flag in 
                owner.setBackgroundColor(flag)
            }
            .disposed(by: disposeBag)
    }
    
    private func setBackgroundColor(_ flag: Bool){
        backgroundColor = flag ? .tnOrangeOff : .tnOrange
    }
}
