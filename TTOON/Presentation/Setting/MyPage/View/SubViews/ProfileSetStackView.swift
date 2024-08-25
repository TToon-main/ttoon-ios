//
//  ProfileSetStackView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

class ProfileSetStackView: BaseView {
    private var infoLabelWidth: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
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
        view.isHidden = true
        
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
        
        infoLabel.snp.makeConstraints { 
            $0.width.lessThanOrEqualTo(180)
        }
        
        container.snp.makeConstraints { 
            $0.height.equalTo(22)
            $0.edges.equalToSuperview()
        }
    }
    
    func setUp(_ model: ProfileStackModel) {
        infoLabel.text = model.title
        copyButton.isHidden = model.isHiddenCopyButton
        
        if let type = model.provider {            
            providerImage.isHidden = false
            providerImage.image = type.buttonImage
        }
    }
}
