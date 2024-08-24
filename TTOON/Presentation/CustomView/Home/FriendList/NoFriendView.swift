//
//  NoFriendView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

class NoFriendView: BaseView {
    let noFriendImageView = {
        let view = UIImageView()
        view.image = TNImage.highFive_gray
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let noFriendLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.text = "아직 추가된 친구가 없어요"
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [noFriendImageView, noFriendLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noFriendImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(163)
        }
        
        noFriendLabel.snp.makeConstraints { make in
            make.top.equalTo(noFriendImageView.snp.bottom).offset(9)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .red.withAlphaComponent(0.1)
    }
}
