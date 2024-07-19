//
//  CalendarView.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import FSCalendar
import UIKit

// 캘린더 화면의 상단.
class CalendarView: BaseView {
    // MARK: - UI Component
    let selectYearMonthView = SelectYearMonthView()
    
    var calendar = FSCalendar()
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        [selectYearMonthView, calendar].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        selectYearMonthView.snp.makeConstraints { make in
            make.top.equalTo(self).inset(24)
            make.leading.equalTo(self).inset(16)
            make.height.equalTo(23)
            make.width.equalTo(130)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(selectYearMonthView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self).inset(12)  // 이게 기본적으로 어느 정도 떨어져 있다..
            make.bottom.equalTo(self).inset(36)
        }
    }
    
    
    // MARK: - Setting
    override func configures() {
        super.configures()
        
        self.backgroundColor = .grey01
        settingCalendar()   // 캘린더 세팅 (UI)
    }
}

extension CalendarView {
    private func settingCalendar() {
        calendar.register(TToonCalendarCell.self, forCellReuseIdentifier: TToonCalendarCell.description())
        
        // 오늘 날짜 선택
//        calendar.setCurrentPage(Date(), animated: true)
//        calendar.select(Date())
        
        // 기존 헤더 제거
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 0 // ??
        
        
        // 주
        calendar.appearance.weekdayFont = .body18m
        calendar.appearance.weekdayTextColor = UIColor(hexString: "#808189")
        calendar.weekdayHeight = 18
        
        
        // 일
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 18)
        calendar.appearance.titleDefaultColor = .white
        
        
        // 기타
        calendar.today = nil
        calendar.scrollEnabled = false
        calendar.scope = .month
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.selectionColor = .clear
        
        
        calendar.placeholderType = .none
    }
}
