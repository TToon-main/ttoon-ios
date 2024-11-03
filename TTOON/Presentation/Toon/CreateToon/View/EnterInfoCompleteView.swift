//
//  EnterInfoCompleteView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/3/24.
//

import UIKit

class EnterInfoCompleteView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.font = .title24b
        view.textColor = .black
        view.text = "만화 생성이 완료되면\n알림을 드릴게요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.text = "써주신 일기 내용을 바탕으로\n만화를 그리는 중이에요!"
        view.numberOfLines = 0
        
        return view
    }()
    
    let imageView = {
        let view = UIImageView()
        view.image = TNImage.createLoadingIcon
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("홈으로 가기", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        [titleLabel, subTitleLabel, imageView, confirmButton].forEach { v in
            addSubview(v)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(52)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(83)
            $0.width.equalTo(222)
            $0.height.equalTo(227.9)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.bottom.equalTo(safeGuide).offset(-36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
 
