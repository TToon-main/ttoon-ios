//
//  AttendanceView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

class AttendanceView: BaseView {
    let navigationBar = {
        let view = AttendanceNavigationBar()
        
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title24b
        view.numberOfLines = 0
        view.text = "매일 출석 체크하고\n포인트를 모아보아요"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.textColor = .grey06
        view.font = .body16m
        view.numberOfLines = 0
        view.text = "모은 포인트로 만화를 다시\n생성할 수 있어요"
        
        return view
    }()
    
    override func addSubViews() {
        [navigationBar, titleLabel, subTitleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    override func layouts() {
        addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { 
            $0.top.equalTo(safeGuide)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { 
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
    }
}
