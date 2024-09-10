//
//  ProfileSummaryView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

import SkeletonView

final class ProfileSummaryView: BaseView {
    let profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = TNImage.userIcon
        
        view.isSkeletonable = true
        view.skeletonCornerRadius = 28
        
        return view
    }()
    
    let profileLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        view.text = "          "

        view.isSkeletonable = true
        view.linesCornerRadius = 6
        
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
        
        view.isSkeletonable = true
        view.skeletonCornerRadius = 9
        
        return view
    }()
    
    lazy var profileSettingButton = {
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
        
        profileLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualTo(profileSettingButton.snp.leading).offset(-25)
            $0.top.equalTo(profileImageView)
        }
    } 
    
    func showSkeleton() {
        [profileImageView, profileLabel, pointContainer]
            .forEach { view in                
                view.showSkeleton(usingColor: .clouds)
            }
    }
    
    func hideSkeleton() {
        [profileImageView, profileLabel, pointContainer]
            .forEach { view in
                view.hideSkeleton(transition: .crossDissolve(0.5))
            }
    }
}
