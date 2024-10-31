//
//  TableViewProfileInfoView.swift
//  TTOON
//
//  Created by 임승섭 on 8/24/24.
//

import UIKit

// height : 36, width : 레이블 길이에 따라 변동
class TableViewProfileInfoView: BaseView {
    // MARK: - UI Component
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.image = TNImage.userIcon
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let profileNicknameLabel = {
        let view = UILabel()
        view.font = .body16m
        view.text = "발랄한 고양이 \(Int.random(in: 0...100))"
        return view
    }()
    
    
    // MARK: - Layout
    override func addSubViews() {
        super.addSubViews()
        
        [profileImageView, profileNicknameLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        profileImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.size.equalTo(36)
        }
        
        profileNicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
    
    func setDesign(_ model: UserInfoModel) {
        // 프로필 이미지
        profileImageView.loadWithKF(
            url: URL(string: model.profileUrl ?? ""),
            defaultImage: TNImage.userIcon
        )
        
        // 닉네임
        profileNicknameLabel.text = model.nickname
    }
}
