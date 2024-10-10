//
//  TToonCalendarCell.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import FSCalendar
import UIKit

class TToonCalendarCell: FSCalendarCell {
    // MARK: - UI Component
    let backView = { // 일기가 없는 날, 기본 색상
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .tnOrangeOff
        return view
    }()
    
    let ttoonImageView = { // 일기가 있는 날, 저장된 그림
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: ["sample1", "sample2", "sample3", "sample4", "sample4"].randomElement()!)
        return view
    }()
    
    let selectedBorderBackgroundView = {    // 선택한 날짜. 주황색 테두리
        let view = UIView()
        view.backgroundColor = .tnOrange
        view.clipsToBounds = true
        return view
    }()
    
    
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        layouts()
        configures()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        ttoonImageView.image = nil
        selectedBorderBackgroundView.isHidden = true
    }
    
    
    // MARK: - UI Layout
    private func layouts() {
        // 디폴트 날짜 레이블의 위치 조정 (정가운데로 조정)
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        
        // 추가로 생성한 imageView 삽입
        contentView.insertSubview(selectedBorderBackgroundView, at: 0)
        contentView.insertSubview(backView, at: 1)
        contentView.addSubview(ttoonImageView)
        
        selectedBorderBackgroundView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(boundSize() + 6)
        }
        backView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(boundSize())
        }
        ttoonImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(boundSize())
        }
        
//        print("**** bound : \(boundSize())")
    }
    
    private func configures() {
        backView.layer.cornerRadius = boundSize()/2
        ttoonImageView.layer.cornerRadius = boundSize()/2
        selectedBorderBackgroundView.layer.cornerRadius = (boundSize() + 6)/2
    }
}


extension TToonCalendarCell {
    private func boundSize() -> CGFloat {
        // 기기 사이즈에 따라 contentView의 크기가 유동적이기 때문에, 가로 세로 중 작은 것 선택
        let w = contentView.bounds.width - 10
        let h = contentView.bounds.height - 10
        
        return (w > h) ? h : w
    }
}
