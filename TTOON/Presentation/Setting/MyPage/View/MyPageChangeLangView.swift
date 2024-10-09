//
//  MyPageChangeLangView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

class MyPageChangeLangView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.text = "언어 설정을 변경해주세요"
        
        return view
    }()
    
    let contentTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(TNSheetCell.self, forCellReuseIdentifier: TNSheetCell.IDF)
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        
        return view
    }()
    
    lazy var container = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 25
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(contentTableView)
        
        return view
    }()
    
    let backgroundView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(container)
    }
    
    override func configures() {
        backgroundColor = .clear
    }
    
    override func layouts() {
        backgroundView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        container.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25)
        }
    }
}
