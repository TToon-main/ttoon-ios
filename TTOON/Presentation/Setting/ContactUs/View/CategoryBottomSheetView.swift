//
//  CategoryBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import UIKit

class CategoryBottomSheetView: BaseView {
    // indicator
    let indicatorView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#E8E8E8")
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    // 타이틀
    let titleLabel = {
        let view = UILabel()
        view.text = "문의 유형을 알려주세요"
        view.font = .title20b
        view.textColor = .black
        return view
    }()
    
    // 테이블뷰
    let categoryTableView = {
        let view = UITableView()
        view.register(TNSheetCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    // 버튼
    let completeButton = {
        let view = TNButton()
        view.setTitle("완료", for: .normal)
        view.isEnabled = false
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [indicatorView, titleLabel, completeButton, categoryTableView].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(49)
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(44)
            make.leading.equalTo(self).inset(21)
            make.height.equalTo(27)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.bottom.horizontalEdges.equalTo(self).inset(16)
        }
        
        categoryTableView.snp.makeConstraints { make in
            // 셀 크기 40이라고 생각하고 계산
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.bottom.equalTo(completeButton.snp.top).inset(-30)
            make.horizontalEdges.equalTo(self)
        }
    }
}
