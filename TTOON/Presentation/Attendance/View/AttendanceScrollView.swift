//
//  AttendanceScrollView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import UIKit

class AttendanceScrollView: BaseView {
    private let attendanceView = AttendanceView()
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        
        return view 
    }()
    
    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(attendanceView)
    }
    
    override func layouts() {
        scrollView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        attendanceView.snp.makeConstraints { 
            $0.width.equalTo(width)
            $0.edges.equalToSuperview()
        }
    }
}
