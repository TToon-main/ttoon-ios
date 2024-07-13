//
//  SelectStyleView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

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
    
    let createToonConfirmButton = {
        let view = TNButton()
        view.isEnabled = false
        view.setTitle("완료", for: .normal)
        
        return view
    }()
    
    override func layouts() {
        flex.direction(.column).padding(16).define { (flex) in
            flex.addItem(titleLabel)
            flex.addItem(subTitleLabel)
            flex.addItem(createToonCollectionView)
            flex.addItem(createToonConfirmButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin.top(safeAreaInsets.top + 36).left(16).sizeToFit()
        subTitleLabel.pin.below(of: titleLabel).marginTop(16).left(16).sizeToFit()
        createToonCollectionView.pin.below(of: subTitleLabel).marginTop(84).horizontally(16).height(132)
        createToonConfirmButton.pin.bottom(safeAreaInsets.bottom + 36).horizontally(16).height(56)
    }
}

extension Reactive where Base: SelectStyleView {
    var modelSelected: Observable<SelectStyleReactor.Action> {
        return base.createToonCollectionView.rx.modelSelected(String.self)
            .map { _ in SelectStyleReactor.Action.modelSelected }
    }
    
    var confirmButtonTap: Observable<SelectStyleReactor.Action> {
        return base.createToonConfirmButton.rx.tap
            .map { _ in SelectStyleReactor.Action.confirmButtonTap }
    }
}

extension Reactive where Base: SelectStyleView {
    var isEnabledConfirmButton: Binder<Bool> {
        return base.createToonConfirmButton.rx.isEnabled
    }
}
