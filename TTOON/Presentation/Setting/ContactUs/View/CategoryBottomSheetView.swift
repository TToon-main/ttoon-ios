//
//  CategoryBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import UIKit

class CategoryBottomSheetView: BaseView {
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
        view.register(TNSheetCellVer2.self, forCellReuseIdentifier: "CategoryTableViewCell")
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
        
        [titleLabel, completeButton, categoryTableView].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
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
