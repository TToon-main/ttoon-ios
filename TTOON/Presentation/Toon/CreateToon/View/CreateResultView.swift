//
//  CreateResultView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import SnapKit

class CreateResultView: BaseView {
    let titleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "만화 생성이 완료되었어요!"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "조혜원님이 써주신 일기를\n바탕으로 네컷만화를 그렸어요"
        
        return view
    }()
    
    let resultImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey01
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("생성된 만화 보러가기", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(resultImageView)
        addSubview(confirmButton)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(36)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        resultImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(195)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeGuide).offset(-36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}
