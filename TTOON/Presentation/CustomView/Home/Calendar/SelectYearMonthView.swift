//
//  SelectYearMonthView.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import RxSwift
import UIKit


// 2024년 5월 + chevron down
// 112 x 23
class SelectYearMonthView: BaseView {
    // MARK: - UI Component
    // 연도 + 월 레이블
    let yearMonthLabel = {
        let view = UILabel()
        view.text = "2024년 5월"
        view.font = .body18m
        return view
    }()
    
    // chevron down
    let chevronImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "chevron.down")
        view.tintColor = .black
        return view
    }()
    
    // 투명 버튼
    let clearButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        [yearMonthLabel, chevronImageView, clearButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        yearMonthLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.leading.equalTo(yearMonthLabel.snp.trailing).offset(7)
            make.height.equalTo(8.73)
            make.centerY.equalTo(self)
        }
        
        clearButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .grey01
    }
}

// TODO: - 레이블 텍스트 변경
extension SelectYearMonthView {
    func updateYearMonth(_ yearMonth: String) {
        yearMonthLabel.text = yearMonth
    }
}
