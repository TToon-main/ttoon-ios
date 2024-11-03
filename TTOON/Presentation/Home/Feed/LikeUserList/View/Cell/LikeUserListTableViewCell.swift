//
//  LikeUserListTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 10/31/24.
//

import UIKit

class LikeUserListTableViewCell: BaseTableViewCell {
    let profileInfoView = TableViewProfileInfoView()
    
    override func addSubViews() {
        super.addSubViews()
        
        [profileInfoView].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        profileInfoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
    }
    
    func setDesign(_ model: UserInfoModel) {
        self.profileInfoView.setDesign(model)
    }
}
