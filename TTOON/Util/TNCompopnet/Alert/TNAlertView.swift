//
//  TNAlertView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/11/24.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class TNAlertView: BaseView {
    private lazy var container = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    lazy var titleMessage  = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        view.textAlignment = .left
        
        return view
    }()
    
    lazy var subTitleMessage = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey07
        view.textAlignment = .left
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var cancelButton = {
        let view = TNAlertButton()
        view.type = .cancel
        view.isHidden = true
        
        return view
    }()
    
    lazy var confirmButton = {
        let view = TNAlertButton()
        view.type = .confirm
        view.isHidden = true
        
        return view
    }()
    
    private lazy var buttonContainer = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.addArrangedSubview(cancelButton)
        view.addArrangedSubview(confirmButton)
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 12
        
        return view
    }()
    
    override func configures() {
        backgroundColor = .black.withAlphaComponent(0.4 )
    }
    
    override func addSubViews() {
        addSubview(container)
    }
    
    override func layouts() {
        container.flex
            .define { flex in
                flex.addItem(titleMessage)
                    .marginTop(24)
                    .marginHorizontal(16)
                    .alignItems(.start)
                
                flex.addItem(subTitleMessage)
                    .marginTop(16)
                    .marginHorizontal(16)
                    .alignItems(.start)
                
                flex.addItem(buttonContainer)
                    .marginTop(39)
                    .marginHorizontal(16)
                    .height(56)
                    .alignItems(.center)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.pin
            .height(200)
            .horizontally(24)
            .center()
        
        container.flex.layout(mode: .fitContainer)
    }
}
