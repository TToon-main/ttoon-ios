//
//  CreateToonCollectionView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

class CreateToonCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        registerCell(cell: CreateToonCollectionViewCell.self)
    }
}
