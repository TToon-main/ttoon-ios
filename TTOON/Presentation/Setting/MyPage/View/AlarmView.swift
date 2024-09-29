//
//  AlarmView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/29/24.
//

import UIKit

class AlarmView: BaseView {
    // MARK: - UI Properties
    
    let titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.text = "생성 완료 알림"
        
        return view
    }()
    
    let subTitleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey07
        view.text = "Toon 생성이 완료되었을 때\n알려드릴게요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let alarmSwitch = TNSwitch()
    
    let container = UIView()
    
    // MARK: - Configurations
    
    override func configures() {
        container.layer.cornerRadius = 25
        container.backgroundColor = .white
        alarmSwitch.isOn = KeychainStorage.shared.isAlarmEnabled
    }
    
    override func addSubViews() {
        addSubview(container)
        
        [titleLabel, subTitleLabel, alarmSwitch].forEach {
            container.addSubview($0)
        }
    }
    
    override func layouts() {
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(safeGuide).inset(16)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        alarmSwitch.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
