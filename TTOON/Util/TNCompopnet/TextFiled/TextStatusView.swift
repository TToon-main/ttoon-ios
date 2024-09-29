//
//  TextStatusView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/31/24.
//

import UIKit

class TextStatusView: BaseView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: 20)
    }
    
    let errorLabel = {
        let view = UILabel()
        view.textColor = .errorRed
        view.font = .body14m
        view.isHidden = true
        
        return view
    }()
    
    let textCntLabel = {
        let view = UILabel()
        view.textColor = .grey05
        view.font = .body14r
        view.textAlignment = .right
        
        return view
    }()
    
    let textLimitLabel = {
        let view = UILabel()
        view.textColor = .grey05
        view.font = .body14r
        view.isHidden = true
        
        return view
    }()
    
    lazy var textCntContainer = {
        let view = UIStackView()
        view.addArrangedSubview(self.textCntLabel)
        view.addArrangedSubview(self.textLimitLabel)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(errorLabel)
        addSubview(textCntContainer)
    }
    
    override func layouts() {
        errorLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(textCntContainer.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        textCntContainer.snp.makeConstraints { 
            $0.leading.equalTo(errorLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(60)
        }
    }
}
