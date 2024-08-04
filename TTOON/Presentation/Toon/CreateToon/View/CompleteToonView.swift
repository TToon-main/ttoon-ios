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
        view.text = "한 컷당 3가지 옵션 중\n고를 수 있어요"
        
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

    override func layouts() {
        super.layouts()
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(selectToonCollectionView)
        addSubview(createToonCompleteToonResultView)
        
        titleLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        selectToonCollectionView.snp.makeConstraints { 
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        createToonCompleteToonResultView.snp.makeConstraints { 
            $0.top.equalTo(selectToonCollectionView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(371)
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
