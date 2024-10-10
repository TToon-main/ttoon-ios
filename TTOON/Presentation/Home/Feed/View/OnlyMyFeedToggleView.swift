//
//  OnlyMyFeedToggleView.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import UIKit

class OnlyMyFeedToggleView: BaseView {
    let onlyMyFeedLabel = {
        let view = UILabel()
        view.font = .body14m
        view.text = "내 피드만 보기"
        return view
    }()
    
    let onlyMyFeedSwitch = TNSwitch()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        [onlyMyFeedLabel, onlyMyFeedSwitch].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        onlyMyFeedSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(16)
        }
        
        onlyMyFeedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(onlyMyFeedSwitch.snp.leading).offset(-8)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .clear
    }
}
