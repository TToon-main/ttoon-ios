//
//  HomeCalendarView.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import UIKit

class HomeCalendarView: BaseView {
    // 스크롤뷰
    // 1. CalendarView
    // 2. bottomDiaryView
    // 3. plusButton
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let calendarView = CalendarView()
    let bottomDiaryView = BottomDiaryView()
//    let plusButton =
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [calendarView, bottomDiaryView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(-100)
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            make.width.equalTo(scrollView)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(80)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(409)
        }
        
        bottomDiaryView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(80)
        }
    }
    
    // MARK: - Setting
    override func configures() {
        super.configures()
        
        bottomDiaryView.roundCorners(cornerRadius: 22, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]) // 적용이 안된다...?
    }
}

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
        layer.masksToBounds = true
    }
}
