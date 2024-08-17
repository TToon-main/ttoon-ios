//
//  SelectYearMonthBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 7/20/24.
//

import UIKit

class SelectYearMonthBottomSheetView: BaseView {
    // MARK: - UI Component
    // 1. Indicator Bar
    let indicatorView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#E8E8E8")
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    // 2. title label
    let titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.text = "어느 날짜로 이동할까요?"
        return view
    }()
    
    // 3. picker view
    let pickerView = {
        let view = UIPickerView()
        return view
    }()
    
    // 4. cancel button
    let cancelButton = {
        let view = TNAlertButton()
        view.type = .cancel
        view.setTitle("취소", for: .normal)
        return view
    }()
    
    // 5. complete button
    let completeButton = {
        let view = TNAlertButton()
        view.type = .confirm
        view.setTitle("확인", for: .normal)
        return view
    }()
    
    // button stackView
    lazy var buttonStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.addArrangedSubview(cancelButton)
        view.addArrangedSubview(completeButton)
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 12
        return view
    }()
    
    
    override func addSubViews() {
        super.addSubViews()
        
        [indicatorView, titleLabel, pickerView, buttonStackView].forEach{
            self.addSubview($0)
        }
    }
    
    override func configures() {
        super.configures()
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(49)
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(28)
            make.leading.equalTo(self).inset(16)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(self).inset(20)
            make.height.equalTo(102)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(56)
        }
    }
}
