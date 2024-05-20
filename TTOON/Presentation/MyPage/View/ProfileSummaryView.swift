//
//  ProfileSummaryView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

final class ProfileSummaryView: BaseView {
    private lazy var profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 28
        view.backgroundColor = .grey01
        
        return view
    }()
    
    private lazy var profileLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        view.makeSampleText(4)
        
        return view
    }()
    
    private lazy var pointImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .grey01
        
        return view
    }()
    
    private lazy var pointLabel = {
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey07
        view.makeSampleText(3)
        
        return view
    }()
    
    private lazy var pointContainer = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 8
        view.addArrangedSubview(pointImageView)
        view.addArrangedSubview(pointLabel)
        
        return view
    }()
    
    private lazy var profileSettingButton = {
        let view = UIButton()
        view.setTitle("프로필 설정", for: .normal)
        view.setTitleColor(.grey03, for: .normal)
        view.titleLabel?.font = .body14m
        view.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
