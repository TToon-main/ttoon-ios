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

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source).asObservable()
    }
    
    var viewWillAppear: Observable<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source).asObservable()
    }
    var viewDidAppear: Observable<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source).asObservable()
    }
    
    var viewWillDisappear: Observable<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source).asObservable()
    }
    var viewDidDisappear: Observable<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source).asObservable()
    }
    
    var viewWillLayoutSubviews: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source).asObservable()
    }
    var viewDidLayoutSubviews: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source).asObservable()
    }
    
    var willMoveToParentViewController: Observable<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source).asObservable()
    }
    var didMoveToParentViewController: Observable<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source).asObservable()
    }
    
    var didReceiveMemoryWarning: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source).asObservable()
    }
    
    /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
    
    /// Rx observable, triggered when the ViewController is being dismissed
    var isDismissing: Observable<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source).asObservable()
    }
}
