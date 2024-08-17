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
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        
        return view
    }()
    
    let selectToonCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let view = CreateToonCompleteToonCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    let createToonCompleteToonResultView = {
        let view = CreateToonCompleteToonResultView()
        
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
        addSubview(selectToonCollectionView)
        addSubview(createToonCompleteToonResultView)
        addSubview(confirmButton)
        
        snp.makeConstraints { 
            $0.width.equalTo(width)
        }
        
        titleLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(68)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        selectToonCollectionView.snp.makeConstraints { 
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(110)
        }
        
        createToonCompleteToonResultView.snp.makeConstraints { 
            $0.top.equalTo(selectToonCollectionView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.top.equalTo(createToonCompleteToonResultView.snp.bottom).offset(43)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(36)
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
            subTitleLabel.text = "원하시면 만화 생성을 다시\n한 번 시도할 수 있어요"
            createToonCompleteToonResultView.subTitleLabel.isHidden = false
            createToonCompleteToonResultView.subTitleLabel.text = "오늘 날씨가 좋아서 오랜만에 한강으로 놀러가서 산책을 했다. 휴학하고 동기들을 오랜만에 보니 참 좋았다. 날씨도 좋아서 산책하는 동안 너무 행복했다. 치킨도 시켜먹었는데 역시 치킨은 굽네가 맛있다!"
            createToonCompleteToonResultView.titleLabel.text = "한강 나들이"
        }
    }
}


extension Reactive where Base: CompleteToonView {
    var selectOrder: Binder<CompleteToonSelectOrderType> {
        return Binder(base) { view, order in
            view.titleLabel.text = order.titleText
        }
    }
}
