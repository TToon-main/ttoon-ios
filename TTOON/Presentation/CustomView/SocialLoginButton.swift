//
//  SocialLoginButton.swift
//  TTOON
//
//  Created by 임승섭 on 5/11/24.
//

import RxSwift
import SnapKit
import UIKit

class SocialLoginButton: BaseView {
    convenience init(socialLoginType: SocialLoginType) {
        self.init()
        
        setUp(type: socialLoginType)
    }
    
    // MARK: - UI Components
    private lazy var titleImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel = {
        let view = UILabel()
        return view
    }()
    
    lazy var clearButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Set UI
    override func addSubViews() {
        super.addSubViews()
        
        [titleImageView, titleLabel, clearButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalTo(self).inset(16)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        clearButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUp(type: SocialLoginType) {
        titleImageView.image = type.buttonImage
        titleLabel.text = type.buttonTitle
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = type.buttonTitleColor
        
        self.backgroundColor = type.buttonBackgroundColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = type.buttonBorderColor.cgColor
    }
}
