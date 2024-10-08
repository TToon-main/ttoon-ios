//
//  FeedLikeButton.swift
//  TTOON
//
//  Created by 임승섭 on 10/8/24.
//

import UIKit

class FeedLikeButton: UIButton {
    var isLiked: Bool = false {
        didSet {
            setUI(isLiked)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(_ isLiked: Bool) {
        setImage(isLiked ? TNImage.feedHeartRed : .feedHeartGray, for: .normal)
    }
}
