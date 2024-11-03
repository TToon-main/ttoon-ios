//
//  PrivacyPolicyTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 11/3/24.
//

import UIKit

class PrivacyPolicyTableViewCell: BaseTableViewCell {
    let titleLabel = {
        let view = UILabel()
        view.font = .body16b
        view.textColor = .grey08
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey07
        view.numberOfLines = 0
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
    
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(36)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
}

extension PrivacyPolicyTableViewCell {
    func setDesign(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
