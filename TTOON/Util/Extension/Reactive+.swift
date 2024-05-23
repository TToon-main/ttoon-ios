//
//  Reactive+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/8/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIControl {
    var isHighlighted: Observable<Bool> {
        base.rx.methodInvoked(#selector(setter: self.base.isHighlighted))
            .map { _ in return self.base.isHighlighted }
            .share()
    }
    
    var isSelected: Observable<Bool> {
        base.rx.methodInvoked(#selector(setter: self.base.isSelected))
            .map { _ in return self.base.isSelected }
            .share()
    }
}
