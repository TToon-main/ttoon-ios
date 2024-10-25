//
//  TNSheetCellVer2.swift
//  TTOON
//
//  Created by 임승섭 on 10/25/24.
//

import UIKit

// 셀 내에서 내부 패딩을 주기 위해, 디자인만 다른 버전으로 새로 만들었습니다

class TNSheetCellVer2: BaseTableViewCell {
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
    
    override func addSubViews() {
        super.addSubViews()
        
        [titleLabel, checkImage].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        checkImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21)
            make.trailing.equalTo(checkImage.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
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
