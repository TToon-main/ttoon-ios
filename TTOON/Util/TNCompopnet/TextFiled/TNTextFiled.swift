//
//  TNTextFiled.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/31/24.
//

import UIKit

import RxCocoa
import RxSwift

class TNTextFiled: BaseView {
    let textFiled = {
        let view = InnerTextField()
        
        return view
    }()
    
    let statusLabel = {
        let view = TextStatusView()
        
        return view
    }()
    
    let container = {
        let view = UIStackView()
        view.spacing = 6
        view.axis = .vertical
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(container)
        container.addArrangedSubview(textFiled)
        container.addArrangedSubview(statusLabel)
    }
    
    override func layouts() {        
        container.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: TNTextFiled {
    var textDidChanged: Observable<String> {
        return base.textFiled.rx.controlEvent(.editingChanged)
            .compactMap { _ in base.textFiled.text }
    }
    
    var text: Binder<String?> {
        return Binder(base) { view, text in
            view.textFiled.text = text
        }
    }
    
    var errorMassage: Binder<String?> {
        return Binder(base) { view, text in
            if let text = text {
                view.statusLabel.errorLabel.text = text
                view.textFiled.layer.borderColor = UIColor.errorRed.cgColor
                view.statusLabel.errorLabel.isHidden = false
                view.layoutIfNeeded()
            } else {
                view.statusLabel.errorLabel.text = nil
                view.textFiled.layer.borderColor = UIColor.clear.cgColor
                view.statusLabel.errorLabel.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
} 
