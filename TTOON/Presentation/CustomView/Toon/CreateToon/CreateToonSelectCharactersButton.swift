//
//  CreateToonSelectCharactersButton.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class CreateToonSelectCharactersButton: UIButton {
    // MARK: - UI Properties
    
    private let btnTitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    private lazy var container = {
        let view = UIStackView()
        view.addArrangedSubview(btnTitleLabel)
        view.addArrangedSubview(arrowImageView)
        view.spacing = 11
        
        return view
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    private func configure() {
        btnTitleLabel.font = .body16m
        container.isUserInteractionEnabled = false
        backgroundColor = .grey01
        layer.cornerRadius = 8
        semanticContentAttribute = .forceRightToLeft
        
        setDefaultText()
    }
    
    private func layouts() {
        addSubview(container)
        
        container.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(22)
        }
    }
    
    // MARK: - Methods
    
    func setSelectedCharactersText(_ text: String) {
        btnTitleLabel.text = text
        btnTitleLabel.textColor = .grey08
        arrowImageView.image = TNImage.btnArrowDownIcon?.withTintColor(.black)
    }
    
    func setDefaultText() {
        btnTitleLabel.text = "저장해둔 등장인물 중 선택해주세요"
        btnTitleLabel.textColor = .grey06
        arrowImageView.image = TNImage.btnArrowDownIcon
    }
}
