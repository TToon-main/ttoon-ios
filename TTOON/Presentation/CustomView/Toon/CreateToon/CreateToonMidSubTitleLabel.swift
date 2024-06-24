//
//  CreateToonMidSubTitleLabel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import Foundation

import UIKit

class CreateToonMidSubTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = .body14r
        textColor = .grey06
        textAlignment = .left
        numberOfLines = 0
    }
}
