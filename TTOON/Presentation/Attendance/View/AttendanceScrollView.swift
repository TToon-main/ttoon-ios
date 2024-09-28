//
//  AttendanceScrollView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class AttendanceScrollView: BaseView {
    // MARK: - UI Properties
    
    private let attendanceView = AttendanceView()
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.backgroundColor = .white
        
        return view 
    }()
    
    // MARK: - Configurations
    
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

// MARK: - Custom Binder

extension Reactive where Base: AttendanceScrollView {
    var isBtnSelected: Binder<[Bool]> {
        return Binder(base) { view, isBtnEnabled in
            _ =    isBtnEnabled.map { isSelected in
                base.attendanceView.fetchButtons().map { $0.isSelected = isSelected}
            }
        }
    }
    
    var showInvalid: Binder<Bool> {
        return Binder(base) { view, isInvalid in
            print("디버그", isInvalid)
        }
    }
    
    var isEnabledCheckAttendanceButton: Binder<Bool> {
        return base.attendanceView.checkAttendanceButton.rx.isEnabled
    }
}

// MARK: - Custom Observable

extension Reactive where Base: AttendanceScrollView {
    var checkAttendanceButtonTap: Observable<Void> {
        return base.attendanceView.checkAttendanceButton.rx.tap
            .asObservable()
    }
}
