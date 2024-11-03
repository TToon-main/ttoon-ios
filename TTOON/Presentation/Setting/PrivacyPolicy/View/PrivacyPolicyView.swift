//
//  PrivacyPolicyView.swift
//  TTOON
//
//  Created by 임승섭 on 11/3/24.
//

import UIKit

class PrivacyPolicyView: BaseView {
    let tableView = {
        let view = UITableView()
        view.register(
            PrivacyPolicyTableViewCell.self,
            forCellReuseIdentifier: PrivacyPolicyTableViewCell.description()
        )
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.allowsSelection = false
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        [tableView].forEach{
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
