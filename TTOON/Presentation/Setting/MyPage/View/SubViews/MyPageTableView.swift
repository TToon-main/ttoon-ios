//
//  MyPageTableView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

struct MyPageTableViewDataSource {
    let sectionTitle: String
    let cellData: [MyPageTableViewCellDataSource]
}

class MyPageTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setTableView()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
        self.bounces = false
        self.rowHeight = 60
        self.sectionFooterHeight = 0
        self.backgroundColor = .white
        self.separatorStyle = .none
    }
}
