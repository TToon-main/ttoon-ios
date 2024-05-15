//
//  TNAlertButton.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/8/24.
//

import UIKit

import RxCocoa
import RxSwift

enum AlertButtonType {
    case cancel
    case confirm
}

class TNAlertButton: UIButton {
    private let disposeBag = DisposeBag()

    override var isEnabled: Bool {
        didSet {
            setBackgroundColor(isEnabled)
        }
    }
    
    var type: AlertButtonType = .confirm {
        didSet {
            setTypeUI(type)
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
        layer.cornerRadius = 14
    }
    
    private func setTypeUI(_ type: AlertButtonType) {
        switch type {
        case .confirm:
            backgroundColor = .tnOrange
            titleLabel?.font = .body16m
            setTitleColor(.white, for: .normal)

        case .cancel:
            backgroundColor = .tnOrangeOff
            titleLabel?.font = .body16m
            setTitleColor(.tnOrange, for: .normal)
        }
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
        if type == .confirm {
            backgroundColor = flag ? .tnOrange.withAlphaComponent(0.3) : .tnOrange  
        } else {
            backgroundColor = flag ? .tnOrangeOff.withAlphaComponent(0.3) : .tnOrangeOff
        }
    }
}
