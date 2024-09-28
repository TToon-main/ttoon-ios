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
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.backgroundColor = .white
        
        return view 
    }()
    
    override func layoutSubviews() {
        scrollView.contentSize = attendanceView.bounds.size
    }
    
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
            $0.top.leading.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(safeGuide)
        }
    }
}
