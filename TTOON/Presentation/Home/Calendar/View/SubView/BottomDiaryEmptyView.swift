//
//  BottomDiaryEmptyView.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import UIKit

class BottomDiaryEmptyView: BaseView {
    convenience init(_ txt: String, img: UIImage) {
        self.init()
        
        self.noDataLabel.text = txt
        self.noDataImageView.image = img
    }
    
    let noDataImageView = {
        let view = UIImageView()
        view.image = TNImage.noFeedDataView
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let noDataLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.text = "해당 일자의 기록이 없어요"
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
            make.top.equalTo(self).inset(44)
            make.centerX.equalTo(self)
            make.height.equalTo(80)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(noDataImageView.snp.bottom).offset(9)
            make.centerX.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.roundCorners(cornerRadius: 22, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
}
