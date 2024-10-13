//
//  AttendanceNavigationBar.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

import RxCocoa
import RxSwift

class AttendanceNavigationBar: BaseView {    
    // MARK: - UI Properties
    
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
    
    // MARK: - Configurations
    
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
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        pointContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(logoImageView)
        }
    }
}

extension Reactive where Base: AttendanceNavigationBar {
    var point: Binder<String?> {
        return base.pointContainer.pointLabel.rx.text
    }
}
