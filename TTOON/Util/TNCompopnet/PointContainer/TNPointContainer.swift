//
//  TNPointContainer.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

import SkeletonView

class TNPointContainer: BaseView {
    let pointImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .grey01
        view.image = TNImage.pointIcon
        
        return view
    }()
    
    let pointLabel = {
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

    override func configures() {
        super.configures()
        backgroundColor = .clear
    }
    
    override func layouts() {
        addSubview(pointContainer)
        
        pointContainer.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        pointImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
}
