//
//  HomeCalendarViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import FSCalendar
import UIKit

class HomeCalendarViewController: BaseViewController {
    // MARK: - UI Component (View)
    let calendarView = CalendarView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectCalendar()
        
        // sample
        view.backgroundColor = .white
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(409)
        }
    }
}



// MARK: - Calendar
extension HomeCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    private func connectCalendar() {
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TToonCalendarCell.description(), for: date, at: position) as? TToonCalendarCell else { return FSCalendarCell() }
        
        cell.ttoonImageView.isHidden = [0, 1].randomElement()! == 0
        
        cell.selectedBorderBackgroundView.isHidden = Calendar.current.dateComponents([.day], from: date).day != 18
        
        return cell
    }
}
