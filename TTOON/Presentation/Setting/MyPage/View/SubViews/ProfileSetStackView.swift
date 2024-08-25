//
//  ProfileSetStackView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

struct ProfileStackModel {
    let title: String
    let provider: SocialLoginType?
    let isHiddenCopyButton: Bool
}

class ProfileSetStackView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = .grey08
        view.font = .body16m
        
        return view
    }()
    
    let providerImage = {
        let view = UIImageView()
        view.isHidden = true
        
        return view
    }()
    
    let infoLabel = {
        let view = UILabel()
        view.textColor = .grey05
        view.font = .body14m
        
        return view
    }()
    
    let copyButton = {
        let view = UIButton()
        view.titleLabel?.font = .body12r
        view.setTitleColor(.grey06, for: .normal)
        view.setTitle("복사", for: .normal)
        view.backgroundColor = .grey01
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var leftContainer = {
        let view = UIStackView()
        view.addArrangedSubview(self.providerImage)
        view.addArrangedSubview(self.infoLabel)
        view.addArrangedSubview(self.copyButton)
        view.setCustomSpacing(8, after: self.providerImage)
        view.setCustomSpacing(11, after: self.infoLabel)
        
        return view
    }()
    
    lazy var container = {
        let view = UIStackView()
        view.addArrangedSubview(self.titleLabel)
        view.addArrangedSubview(self.leftContainer)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(container)
    }
    
    override func layouts() {
        providerImage.snp.makeConstraints { 
            $0.size.equalTo(18)
        }
        
        copyButton.snp.makeConstraints { 
            $0.width.equalTo(41)
            $0.height.equalTo(30)
        }
        
        container.snp.makeConstraints { 
            $0.height.equalTo(22)
            $0.edges.equalToSuperview()
        }
    }
    
    func setUp(_ model: ProfileStackModel) {
        titleLabel.text = model.title
        copyButton.isHidden = model.isHiddenCopyButton
        
        if let type = model.provider {
            providerImage.isHidden = false
        }
    }
}
