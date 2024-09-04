//
//  TToonLogHomeNavigationView.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import UIKit

/* ===== 커스텀 네비게이션 구현 ===== */
// 1. UINavigationBar, UINavigationItem 대신 UIView를 상속한 클래스를 구현하는 이유
//    navigationBar, navigationItem은 get-only property이기 때문에 갈아낄수가 없음
//    그래서 View를 하마 만들어서 기존 navigation에 올리는 방식으로 구현

class TToonLogHomeNavigationView: BaseView {
    let logoImageView = {
        let view = UIImageView()
        view.image = TNImage.homeNavigationLogo
        view.contentMode = .scaleAspectFit
        return view
    }()
    let friendListButton = {
        let view = UIButton()
        view.setImage(TNImage.homeNavigationFriendList, for: .normal)
        return view
    }()
  
    override func addSubViews() {
        super.addSubViews()
        
        [logoImageView, friendListButton].forEach { item in
            self.addSubview(item)
        }
    }
    
    override func layouts() {
        logoImageView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(120)
        }
        friendListButton.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(24)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .clear
    }
}
