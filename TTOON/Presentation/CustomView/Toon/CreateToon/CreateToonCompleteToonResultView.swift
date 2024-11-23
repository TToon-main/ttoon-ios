//
//  CreateToonCompleteToonResultView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import UIKit

class CreateToonCompleteToonResultView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = .grey08
        view.font = .body16b
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.textColor = .grey06
        view.font = .body14r
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var textContainer = {
        let view = UIStackView()
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(subTitleLabel)
        view.axis = .vertical
        view.spacing = 8
        
        return view
    }()
    
    let firstImageView = CreateToonCompleteToonResultImageView(frame: .zero)
    let secondImageView = CreateToonCompleteToonResultImageView(frame: .zero)
    let thirdImageView = CreateToonCompleteToonResultImageView(frame: .zero)
    let forthImageView = CreateToonCompleteToonResultImageView(frame: .zero)
    
    private lazy var imageViews: [CreateToonCompleteToonResultImageView] = [
        firstImageView, secondImageView, thirdImageView, forthImageView
    ]
    
    override func configures() {
        backgroundColor = .grey01
        layer.cornerRadius = 8
    }
    
    override func layouts() {
        addSubview(textContainer)
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(thirdImageView)
        addSubview(forthImageView)
        
        textContainer.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().offset(16)
        }
        
        let imageLength = (width - 27 - 32) / 2
        
        firstImageView.snp.makeConstraints { 
            $0.size.equalTo(imageLength)
            $0.top.equalTo(textContainer.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(secondImageView.snp.leading).offset(-3)
        }
        
        secondImageView.snp.makeConstraints { 
            $0.size.equalTo(imageLength)
            $0.top.equalTo(textContainer.snp.bottom).offset(12)
            $0.leading.equalTo(firstImageView.snp.trailing).offset(3)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        thirdImageView.snp.makeConstraints { 
            $0.size.equalTo(imageLength)
            $0.top.equalTo(firstImageView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(forthImageView.snp.leading).offset(-3)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        forthImageView.snp.makeConstraints { 
            $0.size.equalTo(imageLength)
            $0.top.equalTo(firstImageView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(thirdImageView.snp.trailing).offset(3)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func setImages(urls: [URL]) {
        // 모든 이미지뷰 초기화
        imageViews.forEach { $0.image = nil }
        
        // 선택된 순서대로 이미지 설정
        urls.enumerated().forEach { index, url in
            if index < imageViews.count {
                imageViews[index].loadWithKF(url: url)
            }
        }
    }
}
