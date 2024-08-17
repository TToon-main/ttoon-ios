//
//  CreateToonCollectionViewCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

import RxCocoa
import RxSwift

final class CreateToonCollectionViewCell: BaseCollectionViewCell {
    override var isSelected: Bool {
        didSet {
            setUpIsSelected(isSelected)
        }
    }
    
    let titleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.textAlignment = .center
        
        return view
    }()
    
    let toonImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override func configures() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .grey01
    }
    
    override func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toonImageView)
    }
    
    override func layouts() {
        contentView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { 
            $0.bottom.equalToSuperview().offset(-11)
            $0.centerX.horizontalEdges.equalToSuperview()
        }
        
        toonImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpIsSelected(_ flag: Bool) {
        if flag {
            contentView.backgroundColor = .tnOrangeOff
            contentView.layer.borderColor = UIColor.tnOrange.cgColor
            contentView.layer.borderWidth = 2
        } else {
            contentView.backgroundColor = .grey01
            contentView.layer.borderColor = nil
            contentView.layer.borderWidth = 0
        }
    }
}
