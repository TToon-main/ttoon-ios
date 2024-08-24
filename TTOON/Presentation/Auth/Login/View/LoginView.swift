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
    let logoImageView = {
        let view = UIImageView()
        view.image = TNImage.ttoonLogo
        view.contentMode = .scaleAspectFit
        return view
    }()
    let commentLabel = {
        let view = UILabel()
        view.text = "내 평범한 일상을\n특별한 네컷만화로"
        view.numberOfLines = 2
        view.font = .title20b
        view.textAlignment = .center
        return view
    }()
    let mainImageView = {
        let view = UIImageView()
        view.image = TNImage.createLoadingIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    let appleLoginButton = SocialLoginButton(socialLoginType: .apple)
    let kakaoLoginButton = SocialLoginButton(socialLoginType: .kakao)
    let googleLoginButton = SocialLoginButton(socialLoginType: .google)
    
    
    // MARK: - Set UI
    override func addSubViews() {
        super.addSubViews()
        
        [logoImageView, commentLabel, mainImageView, appleLoginButton, kakaoLoginButton, googleLoginButton].forEach {
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
        
        mainImageView.snp.makeConstraints { make in
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-82)
            make.centerX.equalTo(self)
            make.height.equalTo(210)
            make.width.equalTo(207)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.top).offset(-67)
            
            make.centerX.equalTo(self)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(commentLabel.snp.top).offset(-16)
            make.centerX.equalTo(self)
            make.height.equalTo(36)
            make.width.equalTo(202)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .white
    }
}
