//
//  SelectStyleViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

import RxCocoa
import RxSwift

class SelectStyleViewController: CreateToonBaseViewController {
    private let selectStyleView = SelectStyleView()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = selectStyleView
    }
    
    override func bind() {
        let cells = ["그림체 1", "그림체 2", "그림체 3"] 
        let items = BehaviorSubject(value: cells)
        
        items
            .bind(to: selectStyleView.createToonCollectionView.rx
                .items(cellIdentifier: CreateToonCollectionViewCell.IDF, 
                       cellType: CreateToonCollectionViewCell.self)) 
        { index, item, cell in 
            cell.titleLabel.text = item
            }
        .disposed(by: disposeBag)
        
        
        selectStyleView.createToonCollectionView.rx
            .itemSelected
            .subscribe(with: self ) { owner, indexPath in 
                guard let cell = owner.selectStyleView.createToonCollectionView.cellForItem(at: indexPath) else {
                    return
                }
                    
                cell.isSelected = true
            }
            .disposed(by: disposeBag)
        
        selectStyleView.createToonCollectionView.rx
            .itemDeselected
            .subscribe(with: self ) { owner, indexPath in 
                guard let cell = owner.selectStyleView.createToonCollectionView.cellForItem(at: indexPath) else {
                    return
                }
                    
                cell.isSelected = false
            }
            .disposed(by: disposeBag)
    }
}
