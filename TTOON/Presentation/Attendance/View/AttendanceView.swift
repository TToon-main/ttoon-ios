//
//  AttendanceView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

class AttendanceView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title24b
        view.numberOfLines = 0
        view.text = "매일 출석 체크하고\n포인트를 모아보아요"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.textColor = .grey06
        view.font = .body16m
        view.numberOfLines = 0
        view.text = "모은 포인트로 만화를 다시\n생성할 수 있어요"
        
        return view
    }()
    
    let checkAttendanceButton = {
        let view = TNButton()
        view.setTitle("출석체크하기", for: .normal)
        
        return view
    }()
    
    let firstAttendanceButtonStackView = AttendanceButtonStackView(type: .firstLine)
    
    let secondAttendanceButtonStackView = AttendanceButtonStackView(type: .secondLine)
    
    let thirdAttendanceButtonStackView = AttendanceButtonStackView(type: .thirdLine)
    
    override func addSubViews() {
        [titleLabel,
         subTitleLabel,
         checkAttendanceButton,
         firstAttendanceButtonStackView,
         secondAttendanceButtonStackView,
         thirdAttendanceButtonStackView].forEach { view in
            self.addSubview(view)
        }
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        firstAttendanceButtonStackView.snp.makeConstraints { 
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(128)
        }
        
        secondAttendanceButtonStackView.snp.makeConstraints { 
            $0.top.equalTo(firstAttendanceButtonStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(128)
        }
        
        thirdAttendanceButtonStackView.snp.makeConstraints {
            $0.top.equalTo(secondAttendanceButtonStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(128)
            $0.bottom.lessThanOrEqualTo(checkAttendanceButton.snp.top).offset(-44)
        }
        
        checkAttendanceButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}
