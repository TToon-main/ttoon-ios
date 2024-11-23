//
//  HomeCalendarView.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import UIKit

import RxCocoa
import RxSwift

class HomeCalendarView: BaseView {
    // 스크롤뷰
    // 1. CalendarView
    // 2. bottomDiaryView
    // 3. plusButton
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let calendarView = CalendarView()
    let bottomDiaryView = BottomDiaryView()
    let bottomDiaryEmptyView = BottomDiaryEmptyView()
    
    let plusButton = {
        let view = UIButton()
        view.setImage(TNImage.homePlusButton, for: .normal)
        
        return view
    }()
    
    let toonCreationToastView = {
        let view = ToonCreationToastView()
        view.status = .idle
        view.isHidden = true
        
        return view
    }()
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [calendarView, bottomDiaryView, bottomDiaryEmptyView, plusButton, toonCreationToastView].forEach { item in
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
            make.top.equalTo(contentView).inset(100)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(409)
        }
        
        bottomDiaryView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        bottomDiaryEmptyView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(111)
        }
        
        toonCreationToastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeGuide).offset(-16)
        }
    }
    
    // MARK: - Setting
    override func configures() {
        super.configures()
        
        self.backgroundColor = .grey01
        scrollView.bounces = false
    }
}

extension HomeCalendarView {
    func updateView(_ model: FeedModel?) {
        if let model {
            // 데이터 있을 때
            bottomDiaryView.isHidden = false
            bottomDiaryEmptyView.isHidden = true
            
            bottomDiaryView.updateView(model)
        } else {
            // 데이터 없을 때
            bottomDiaryView.isHidden = true
            bottomDiaryEmptyView.isHidden = false
        }
    }
    
    func isHiddenPlusButton(_ status: CreateToonStatus) {
        var isHidden: Bool
        
        switch status {
        case .idle:
            isHidden = false
            
        case .ing:
            isHidden = true
            
        case .complete:
            isHidden = true
        }
        
        toonCreationToastView.isHidden = !isHidden
        plusButton.isHidden = isHidden
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

extension Reactive where Base: HomeCalendarView {
    var setCreatToonToastStatus: Binder<CreateToonStatus> {
        return Binder(base) { view, status in
            UIView.animate(withDuration: 0.3) {
                view.toonCreationToastView.setUI(status)
                view.isHiddenPlusButton(status)
            }
        }
    }
    
    var completeToastTap: Observable<SaveToon> {
        return base.toonCreationToastView.rx.buttonTap
            .do { _ in base.toonCreationToastView.setUI(.idle)}
            .do { _ in base.isHiddenPlusButton(.idle)}
    }
}
