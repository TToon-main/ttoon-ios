//
//  SelectStyleView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

class SelectStyleView: BaseView {
    let titleLabel = {
        let view = CreateToonTitleLabel()
        view.text = "가장 마음에 드는 그림체를\n선택해주세요"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "골라주신 그림체로 네컷만화를\n생성해드릴게요"
        
        return view
    }()
    
    let createToonCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 106, height: 132)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let view = CreateToonCollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(createToonCollectionView)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        createToonCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(84)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(132)
        }
    }
}
