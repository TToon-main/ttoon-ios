//
//  AttendanceNavigationBar.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

class AttendanceNavigationBar: BaseView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 50)
    }
    
    let logoImageView = {
        let view = UIImageView()
        view.image = TNImage.homeNavigationLogo
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let pointContainer = {
        let view = TNPointContainer()
        
        return view
    }()
    
    override func configures() {
        super.configures()
        self.backgroundColor = .clear
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [logoImageView, pointContainer].forEach { item in
            self.addSubview(item)
        }
    }
    
    override func layouts() {
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        pointContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }
    }
}
