//
//  NoFriendView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

class NoDataView: BaseView {
    convenience init(_ txt: String) {
        self.init()
        self.noDataLabel.text = txt
    }
    
    let noDataImageView = {
        let view = UIImageView()
        view.image = TNImage.highFive_gray
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let noDataLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.text = "아직 추가된 친구가 없어요"
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [noDataImageView, noDataLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        noDataImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(163)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(noDataImageView.snp.bottom).offset(9)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
