//
//  MyPageTableViewCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

struct MyPageTableViewCellDataSource {
    let title: String
    let info: String?
    let isArrowVisible: Bool
    
    init(title: String, info: String? = nil, isArrowVisible: Bool = false) {
        self.title = title
        self.info = info
        self.isArrowVisible = isArrowVisible
    }
}

class MyPageTableViewCell: BaseTableViewCell {
    lazy var titleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .black
        view.makeSampleText(3)
        
        return view
    }()
    
    lazy var infoLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .body14m
        view.textColor = .grey05
        view.makeSampleText(2)
        
        return view
    }()
    
    private lazy var arrowImage = {
        let view = UIImageView()
        view.backgroundColor = .grey05
        
        return view
    }()
    
    private lazy var container = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.addArrangedSubview(infoLabel)
        view.addArrangedSubview(arrowImage)
        view.spacing = 4
        
        return view
    }()
    
    override func configures() {
        selectionStyle = .none
    }
    
    override func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(container)
    }
    
    override func layouts() {    
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setCell(_ data: MyPageTableViewCellDataSource) {
        titleLabel.text = data.title
        arrowImage.isHidden = data.isArrowVisible
        infoLabel.text = data.info
    }
}
