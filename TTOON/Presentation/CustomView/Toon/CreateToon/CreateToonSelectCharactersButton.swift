//
//  CreateToonSelectCharactersButton.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

class CreateToonSelectCharactersButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .grey01
        titleLabel?.font = .body16m
        setTitleColor(.grey06, for: .normal)
        setTitle("저장해 둔 등장인물 중 선택해주세요.", for: .normal)
        semanticContentAttribute = .forceLeftToRight
        layer.cornerRadius = 8
    }
}
