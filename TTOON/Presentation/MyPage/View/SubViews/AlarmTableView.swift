//
//  AlarmTableView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

struct AlarmTableViewDataSource {
    let sectionTitle: String
    let cellData: [MyPageTableViewCellDataSource]
}

class AlarmTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setTableView()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")
        self.bounces = false
        self.rowHeight = 106
        self.sectionFooterHeight = 0
        self.backgroundColor = .white
    }
}
