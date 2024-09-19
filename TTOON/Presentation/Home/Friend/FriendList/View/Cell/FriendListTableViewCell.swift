//
//  FriendListTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import RxSwift
import UIKit

// 이미지, 닉네임, 버튼('친구 삭제')
// cell height 76
class FriendListTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    
    let profileInfoView = TableViewProfileInfoView()
    
    let deleteFriendButton = UserListTableViewButton()
    
    override func addSubViews() {
        super.addSubViews()
        
        [profileInfoView, deleteFriendButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        deleteFriendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.equalTo(84)
            make.height.equalTo(36)
        }
        
        profileInfoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deleteFriendButton.snp
                .leading).offset(-4)
        }
    }
    
    override func configures() {
        super.configures()
        
        deleteFriendButton.type = .deleteFriend
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func setDesign(_ model: UserInfoModel) {
        self.profileInfoView.setDesign(model)
    }
}
