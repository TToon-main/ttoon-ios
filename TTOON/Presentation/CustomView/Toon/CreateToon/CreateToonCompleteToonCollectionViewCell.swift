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
    var isSelected: Bool
    let imageUrl: URL
}

final class CreateToonCompleteToonCollectionViewCell: BaseCollectionViewCell {
    let toonImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let opacityView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.65)
        
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toonImageView.image = nil
        setUpIsSelected(false)
    }
    
    override func configures() {
        contentView.layer.cornerRadius = 5
    }
    
    override func addSubViews() {
        contentView.addSubview(toonImageView)
        contentView.addSubview(opacityView)
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
        setUpIsSelected(item.isSelected)
        toonImageView.loadWithKF(url: item.imageUrl)
    }
}
