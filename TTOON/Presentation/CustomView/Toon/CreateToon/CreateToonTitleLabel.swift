//
//  CreateToonTitleLabel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

class CreateToonTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = .title24b
        textColor = .black
        textAlignment = .left
        numberOfLines = 0
    }
}
