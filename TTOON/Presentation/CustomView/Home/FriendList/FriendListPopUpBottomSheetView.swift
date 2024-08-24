//
//  FriendListPopUpBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 8/23/24.
//

import UIKit

class FriendListPopUpBottomSheetView: BaseView {
    // cancelButtonTitle을 nil로 넣으면 버튼 하나만 생기도록 구현
    init(
        title: String,
        subTitle: String,
        image: UIImage,
        confirmButtonTitle: String,
        cancelButtonTitle: String?
    ) {
        super.init(frame: .zero)
        
        setData(title: title, subTitle: subTitle, image: image, confirmButtonTitle: confirmButtonTitle, cancelButtonTitle: cancelButtonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Component
    let indicatorView = IndicatorView()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey07
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    lazy var cancelButton = {
        let view = TNAlertButton()
        view.type = .cancel
//        view.isHidden =
        return view
    }()
    
    lazy var confirmButton = {
        let view = TNAlertButton()
        view.type = .confirm
        return view
    }()
    
    
    private lazy var buttonStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.addArrangedSubview(cancelButton)
        view.addArrangedSubview(confirmButton)
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 12
        return view
    }()
    
    
    // MARK: - Layout
    override func addSubViews() {
        super.addSubViews()
        
        [indicatorView, titleLabel, subTitleLabel, buttonStackView, iconImageView].forEach{ self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
    
        titleLabel.setContentHuggingPriority(
            .init(999),
            for: .vertical
        )
        
        subTitleLabel.setContentHuggingPriority(
            .init(999),
            for: .vertical
        )
        
        iconImageView.setContentHuggingPriority(
            .init(800),
            for: .vertical
        )
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(49)
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(44)
            make.leading.equalTo(self).inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(self).inset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self).inset(16)
            make.height.equalTo(56)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
            make.centerX.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
    }
}


extension FriendListPopUpBottomSheetView {
    private func setData(
        title: String,
        subTitle: String,
        image: UIImage,
        confirmButtonTitle: String,
        cancelButtonTitle: String?
    ) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        iconImageView.image = image
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        
        if let cancelButtonTitle {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
        
        layoutSubviews()
    }
}
