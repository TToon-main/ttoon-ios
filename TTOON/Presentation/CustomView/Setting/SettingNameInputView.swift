//
//  SettingNameInputView.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import UIKit

class SettingNameInputView: UIView {
    convenience init(_ name: String) {
        self.init()
        
        self.nameLabel.text = name
        setUp()
    }
    
    let nameLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey05
        return view
    }()
    
    private func setUp() {
        // border
        clipsToBounds = true
        layer.borderColor = UIColor.grey03.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        // layout
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(20)
        }
    }
}
