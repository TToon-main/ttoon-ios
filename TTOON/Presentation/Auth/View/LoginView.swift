//
//  LoginView.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import SnapKit
import UIKit


class LoginView: BaseView {
    // MARK: - UI Properties
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let googleLoginButton = UIButton()
    
    
    
    // MARK: - Set UI
    override func addSubViews() {
        super.addSubViews()
        
        [appleLoginButton, kakaoLoginButton, googleLoginButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self).inset(50)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .purple
        
        
        appleLoginButton.backgroundColor = .black
        kakaoLoginButton.backgroundColor = .yellow
        googleLoginButton.backgroundColor = .blue
    }
}
