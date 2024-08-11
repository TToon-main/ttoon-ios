//
//  CreateToonCompleteToonCollectionViewCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import UIKit

import RxCocoa
import RxSwift

struct CreateToonCompleteToonCollectionViewCellDataSource {
    let isSelected: Bool
}

final class CreateToonCompleteToonCollectionViewCell: BaseCollectionViewCell {
    override var isSelected: Bool {
        didSet {
            setUpIsSelected(isSelected)
        }
    }
    
    let opacityView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        
        return view
    }()
    
    let toonImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override func configures() {
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .tnOrange
    }
    
    override func addSubViews() {
        contentView.addSubview(opacityView)
        contentView.addSubview(toonImageView)
    }
    
    override func layouts() {
        contentView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        toonImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpIsSelected(_ flag: Bool) {
        if flag {
            contentView.layer.borderColor = UIColor.tnOrange.cgColor
            contentView.layer.borderWidth = 2
            opacityView.isHidden = true
        } else {
            contentView.layer.borderColor = nil
            contentView.layer.borderWidth = 0
            opacityView.isHidden = false
        }
    }
    
    func setCell(_ item: CreateToonCompleteToonCollectionViewCellDataSource) {
        isSelected = item.isSelected
    }
}
