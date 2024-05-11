//
//  LoginView.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import SnapKit
import UIKit


class LoginView: BaseView {
    // MARK: - UI Components
    let appleLoginButton = SocialLoginButton(socialLoginType: .apple)
    let kakaoLoginButton = SocialLoginButton(socialLoginType: .kakao)
    let googleLoginButton = SocialLoginButton(socialLoginType: .google)
    
    
    // MARK: - Set UI
    override func addSubViews() {
        super.addSubViews()
        
        [appleLoginButton, kakaoLoginButton, googleLoginButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        googleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(72)
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(-12)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(googleLoginButton.snp.top).offset(-12)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-12)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(50)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .white
    }
}
