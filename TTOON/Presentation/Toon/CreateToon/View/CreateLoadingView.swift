//
//  CreateLoadingView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import SnapKit

class CreateLoadingView: BaseView {
    var progressLabelLeading: Constraint?
    
    let createLoadingImageView = {
        let view = UIImageView()
        view.image = TNImage.createLoadingIcon
        
        return view
    }()
    
    let progressBar = {
        let view = UIProgressView()
        view.progress = 0.5
        view.progressTintColor = .tnOrange
        view.backgroundColor = .grey01
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "써주신 일기 내용을 바탕으로\n만화를 그리는 중이에요!"
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(createLoadingImageView)
        addSubview(progressBar)
        addSubview(subTitleLabel)
    }
    
    override func layouts() {
        createLoadingImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(height * 0.25)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(144)
            $0.width.equalTo(140)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(createLoadingImageView.snp.bottom).offset(55)
            $0.horizontalEdges.equalToSuperview().inset(72)
            $0.height.equalTo(12)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(86)
        }
    }
}
