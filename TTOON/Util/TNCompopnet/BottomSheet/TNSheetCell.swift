//
//  TNSheetCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/12/24.
//

import UIKit

import FlexLayout
import PinLayout

class TNSheetCell: BaseTableViewCell {
    var isChecked: Bool = false {
        didSet {
            setSelectedUI(isChecked)
        }
    }
    
    lazy var titleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey05
        
        return view
    }()
    
    lazy var checkImage = {
        let view = UIImageView()
        view.image = TNImage.doneRound
        view.isHidden = true
        
        return view
    }()
        
    override func layoutSubviews() {
        contentView.pin.all()
        contentView.flex
            .layout()
    }
    
    override func layouts() {
        contentView.flex
            .direction(.row)
            .alignItems(.center) // 추가된 부분
            .define { flex in
                flex.addItem(titleLabel)
                    .marginLeft(20)
                    .marginVertical(0)
                    .grow(1)

                flex.addItem(checkImage)
                    .marginRight(20)
                    .marginVertical(10)
                    .size(24)
            }
    }
    
    private func setSelectedUI(_ isSelected: Bool) {
        if isSelected {
            titleLabel.textColor = .black
            checkImage.isHidden = false
        } else {
            titleLabel.textColor = .grey05
            checkImage.isHidden = true
        }
    }
}
