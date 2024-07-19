//
//  BottomDiaryImageSwipeCollectionViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import UIKit

class BottomDiaryImageSwipeCollectionViewCell: BaseCollectionViewCell {
    // MARK: - UI Component
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(imageView)
    }
    
    override func layouts() {
        super.layouts()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    
    // MARK: - Setting
    override func configures() {
        super.configures()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 7
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
