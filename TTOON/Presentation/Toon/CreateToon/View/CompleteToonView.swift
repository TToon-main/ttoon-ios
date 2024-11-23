//
//  CompleteToonView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import UIKit

import RxCocoa
import RxSwift

class CompleteToonView: BaseView {
    let titleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "각 장면에 들어갈\n그림을 선택해주세요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "한 컷당 3가지 옵션 중\n고를 수 있어요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let selectToonCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let view = CreateToonCompleteToonCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    let createToonCompleteToonResultView = {
        let view = CreateToonCompleteToonResultView()
        
        return view
    }()
    
    lazy var container = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        view.addArrangedSubview(selectToonCollectionView)
        view.addArrangedSubview(createToonCompleteToonResultView)
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        
        return view
    }()
    
    override func layouts() {
        super.layouts()
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(container)
        addSubview(confirmButton)
        
        snp.makeConstraints { 
            $0.width.equalTo(width)
        }
        
        titleLabel.snp.makeConstraints { 
            $0.top.equalTo(safeGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(68)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        container.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        selectToonCollectionView.snp.makeConstraints {
            $0.height.equalTo(110)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.top.equalTo(createToonCompleteToonResultView.snp.bottom).offset(43)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-36)
        }
    }
    
    func setUpView(isCompleted: Bool) {
        if !isCompleted {
            titleLabel.text = "마지막 장면에 들어갈\n그림을 선택해주세요"
            subTitleLabel.text = "한 컷당 3가지 옵션 중\n고를 수 있어요"
            createToonCompleteToonResultView.subTitleLabel.isHidden = true
            createToonCompleteToonResultView.titleLabel.text = "적용된 모습"
        } else {
            titleLabel.text = "네컷만화가 완성되었어요!"
            subTitleLabel.text = "완성된 만화는 캘린더와\n피드에서 언제든 확인해요"
            createToonCompleteToonResultView.subTitleLabel.isHidden = false
            createToonCompleteToonResultView.subTitleLabel.text = UserDefaultsManager.toonInfoContents
            createToonCompleteToonResultView.titleLabel.text = UserDefaultsManager.toonInfoTitle
            selectToonCollectionView.isHidden = true
            confirmButton.setTitle("이대로 저장", for: .normal)
        }
    }
}
