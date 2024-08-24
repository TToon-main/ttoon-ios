//
//  ProfileSummaryView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

final class ProfileSummaryView: BaseView {
    lazy var profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 28
        view.backgroundColor = .grey01
        view.image =  TNImage.userIcon
        
        return view
    }()
    
    lazy var profileLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        
        return view
    }()
    
    lazy var pointImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .grey01
        view.image = TNImage.pointIcon
        
        return view
    }()
    
    lazy var pointLabel = {
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey07
        
        return view
    }()
    
    private lazy var pointContainer = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 4
        view.addArrangedSubview(pointImageView)
        view.addArrangedSubview(pointLabel)
        
        return view
    }()
    
    private lazy var profileSettingButton = {
        let view = UIButton()
        view.setTitle("프로필 설정", for: .normal)
        view.setTitleColor(.textMidGrey03, for: .normal)
        view.titleLabel?.font = .body14m
        view.setImage(TNImage.arrowSmallLight?.withTintColor(.textMidGrey03), for: .normal)
        view.semanticContentAttribute = .forceRightToLeft
        
        return view
    }()
    
    
    override func addSubViews() {
        addSubview(profileImageView)
        addSubview(profileLabel)
        addSubview(pointContainer)
        addSubview(profileSettingButton)
    }
    
    override func layouts() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(29)
            $0.size.equalTo(56)
        }
        
        profileLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(110)
            $0.top.equalTo(profileImageView)
        }
        
        pointImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }

        pointContainer.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.bottom.equalTo(profileImageView)
        }
        
        profileSettingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(profileLabel.snp.top).offset(16)
        }
    }   
}
