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
    
    override func addSubViews() {
        [navigationBar].forEach { view in
            self.addSubview(view)
        }
    }
    
    override func layouts() {
        addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { 
            $0.top.equalTo(safeGuide)
            $0.centerX.equalToSuperview()
        }
    }
}
