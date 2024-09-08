//
//  ReceivedFriendRequestTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import Foundation
import RxSwift

// 이미지, 닉네임, 버튼('수락'), 버튼('거절')
class ReceivedFriendRequestTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    
    let profileInfoView = TableViewProfileInfoView()
    
    let acceptButton = UserListTableViewButton()
    let rejectButton = UserListTableViewButton()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        [profileInfoView, acceptButton, rejectButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        rejectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(36)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.trailing.equalTo(rejectButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(36)
        }
        
        profileInfoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(acceptButton.snp
                .leading).offset(-4)
        }
    }
    
    override func configures() {
        super.configures()
        
        acceptButton.type = .accept
        rejectButton.type = .reject
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
