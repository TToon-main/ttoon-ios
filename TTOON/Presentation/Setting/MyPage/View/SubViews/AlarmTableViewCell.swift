//
//  AlarmTableViewCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import Foundation

import UIKit

struct AlarmTableViewCellDataSource {
    let title: String
    let subTitle: String
    let isOn: Bool
    
    init(title: String, subTitle: String, isOn: Bool = false) {
        self.title = title
        self.subTitle = subTitle
        self.isOn = isOn
    }
}

class AlarmTableViewCell: BaseTableViewCell {
    private lazy var titleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .black
        view.makeSampleText(3)
        
        return view
    }()
    
    private lazy var subTitleLabel = {
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey06
        view.numberOfLines = 0
        view.makeSampleText(30)
        
        return view
    }()
    
    private lazy var isOnSwitch = {
        let view = TNSwitch()
        view.isOn = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    override func configures() {
        selectionStyle = .none
    }
    
    override func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(isOnSwitch)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(234)
        }
        
        isOnSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setCell(_ data: AlarmTableViewCellDataSource) {
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        isOnSwitch.isOn = data.isOn
    }
}
